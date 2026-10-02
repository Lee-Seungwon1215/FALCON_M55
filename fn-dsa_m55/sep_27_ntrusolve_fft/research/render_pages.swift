import Foundation
import PDFKit
import AppKit
let args=CommandLine.arguments
guard args.count >= 4, let doc=PDFDocument(url: URL(fileURLWithPath:args[1])) else {
    fatalError("render_pages input.pdf output-dir page [page...]")
}
let dir=URL(fileURLWithPath:args[2],isDirectory:true)
try FileManager.default.createDirectory(at:dir,withIntermediateDirectories:true)
for argument in args.dropFirst(3) {
    guard let number=Int(argument), let page=doc.page(at:number-1) else {fatalError("page")}
    let bounds=page.bounds(for:.mediaBox)
    let image=page.thumbnail(of:NSSize(width:1500,height:1500*bounds.height/bounds.width),for:.mediaBox)
    guard let tiff=image.tiffRepresentation, let bitmap=NSBitmapImageRep(data:tiff),
          let png=bitmap.representation(using:.png,properties:[:]) else {fatalError("bitmap")}
    try png.write(to:dir.appendingPathComponent(String(format:"%03d.png",number)))
}
