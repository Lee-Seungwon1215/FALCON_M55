import Foundation
import PDFKit
import CryptoKit
import Vision
import AppKit

// Reproducible, page-indexed extraction of user-provided local PDFs.
let args = CommandLine.arguments
guard args.count == 3 else { fatalError("usage: extract_papers REFERENCE OUTPUT") }
let input = URL(fileURLWithPath: args[1], isDirectory: true)
let output = URL(fileURLWithPath: args[2], isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let files = try FileManager.default.contentsOfDirectory(at: input, includingPropertiesForKeys: nil)
    .filter { $0.pathExtension.lowercased() == "pdf" }.sorted { $0.lastPathComponent < $1.lastPathComponent }
var manifest = [[String: Any]]()
for file in files {
    guard let document = PDFDocument(url: file) else { fatalError("unreadable PDF: \(file.path)") }
    let directory = output.appendingPathComponent(file.deletingPathExtension().lastPathComponent)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    var counts = [Int]()
    for index in 0..<document.pageCount {
        guard let page = document.page(at: index) else { fatalError("missing page") }
        var body = page.string ?? ""
        if body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let bounds = page.bounds(for: .mediaBox)
            let thumbnail = page.thumbnail(of: NSSize(width: 1800, height: 1800*bounds.height/bounds.width), for: .mediaBox)
            var rect = NSRect(origin: .zero, size: thumbnail.size)
            guard let bitmap = thumbnail.cgImage(forProposedRect: &rect, context: nil, hints: nil) else { fatalError("OCR bitmap") }
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            request.usesLanguageCorrection = false
            request.usesCPUOnly = true
            try VNImageRequestHandler(cgImage: bitmap).perform([request])
            body = "[OCR: verify mathematical symbols against the PDF]\n" + (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
        }
        let text = "DOCUMENT: \(file.lastPathComponent) PAGE: \(index+1)/\(document.pageCount)\n\n" + body + "\n"
        try text.write(to: directory.appendingPathComponent(String(format: "%03d.txt", index+1)), atomically: true, encoding: .utf8)
        counts.append(body.count)
    }
    let digest = SHA256.hash(data: try Data(contentsOf: file)).map { String(format: "%02x", $0) }.joined()
    manifest.append(["source":file.path,"sha256":digest,"pages":document.pageCount,
                     "characters_per_page":counts,"output":directory.path])
    print("PDF \(file.lastPathComponent) pages=\(document.pageCount) chars=\(counts.reduce(0,+))")
}
try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
    .write(to: output.appendingPathComponent("manifest.json"))
