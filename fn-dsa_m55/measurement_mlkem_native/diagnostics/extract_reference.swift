// Read-only PDF text extraction using the macOS system PDFKit framework.
import Foundation
import PDFKit
import AppKit

let args = CommandLine.arguments
guard args.count >= 2, let document = PDFDocument(url: URL(fileURLWithPath: args[1])) else {
    fputs("Usage: extract_reference.swift PDF [first-page last-page]\n", stderr)
    exit(1)
}
if args.count == 5 && args[2] == "--render" {
    guard let number = Int(args[3]), let page = document.page(at: number - 1) else { exit(2) }
    let image = page.thumbnail(of: NSSize(width: 1400, height: 1900), for: .mediaBox)
    guard let tiff = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else { exit(3) }
    try png.write(to: URL(fileURLWithPath: args[4]))
    exit(0)
}
let first = args.count > 2 ? Int(args[2])! : 1
let last = args.count > 3 ? Int(args[3])! : document.pageCount
guard first >= 1, last <= document.pageCount, first <= last else { exit(2) }
print("PDF_PAGE_COUNT=\(document.pageCount)")
for number in first...last {
    print("\n=== PDF PAGE \(number) ===\n")
    print(document.page(at: number - 1)?.string ?? "<no text>")
}
