import AppKit

let fileManager = FileManager.default
let sourcePath = "src/assets/og-portrait.jpg"
let outputPath = "public/og-image.png"

guard fileManager.fileExists(atPath: sourcePath) else {
  fputs("Source portrait not found at \(sourcePath)\n", stderr)
  exit(1)
}

guard let portrait = NSImage(contentsOfFile: sourcePath) else {
  fputs("Unable to load portrait image.\n", stderr)
  exit(1)
}

let canvasSize = NSSize(width: 1200, height: 630)
let panelRect = NSRect(x: 72, y: 72, width: 1056, height: 486)
let photoRect = NSRect(x: 744, y: 141, width: 308, height: 308)
let textLeft: CGFloat = 112

let backgroundTop = NSColor(calibratedRed: 0.984, green: 0.98, blue: 0.965, alpha: 1)
let backgroundBottom = NSColor(calibratedRed: 0.957, green: 0.937, blue: 0.898, alpha: 1)
let panelFill = NSColor(calibratedRed: 1, green: 0.992, blue: 0.973, alpha: 1)
let panelStroke = NSColor(calibratedWhite: 0.09, alpha: 0.12)
let nameColor = NSColor(calibratedRed: 0.09, green: 0.078, blue: 0.067, alpha: 1)
let mutedColor = NSColor(calibratedRed: 0.392, green: 0.357, blue: 0.325, alpha: 1)

func font(_ name: String, size: CGFloat, fallback: NSFont) -> NSFont {
  NSFont(name: name, size: size) ?? fallback
}

let nameFont = font("Palatino-Bold", size: 72, fallback: .boldSystemFont(ofSize: 72))
let roleFont = font("Palatino-Roman", size: 36, fallback: .systemFont(ofSize: 36, weight: .regular))
let metaFont = font("Palatino-Roman", size: 27, fallback: .systemFont(ofSize: 27, weight: .regular))
let domainFont = font("Palatino-Semibold", size: 24, fallback: .systemFont(ofSize: 24, weight: .semibold))

func paragraph(lineHeight: CGFloat? = nil) -> NSMutableParagraphStyle {
  let style = NSMutableParagraphStyle()
  style.lineBreakMode = .byWordWrapping
  if let lineHeight = lineHeight {
    style.minimumLineHeight = lineHeight
    style.maximumLineHeight = lineHeight
  }
  return style
}

func drawText(_ text: String, rect: NSRect, font: NSFont, color: NSColor, lineHeight: CGFloat? = nil) {
  let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: color,
    .paragraphStyle: paragraph(lineHeight: lineHeight),
  ]

  NSString(string: text).draw(
    with: rect,
    options: [.usesLineFragmentOrigin, .usesFontLeading],
    attributes: attributes
  )
}

func drawCroppedImage(_ image: NSImage, in destinationRect: NSRect, cornerRadius: CGFloat) {
  let path = NSBezierPath(roundedRect: destinationRect, xRadius: cornerRadius, yRadius: cornerRadius)
  path.addClip()

  let sourceSize = image.size
  let sourceRatio = sourceSize.width / sourceSize.height
  let destinationRatio = destinationRect.width / destinationRect.height

  var sourceRect = NSRect(origin: .zero, size: sourceSize)

  if sourceRatio > destinationRatio {
    let newWidth = sourceSize.height * destinationRatio
    sourceRect.origin.x = (sourceSize.width - newWidth) / 2
    sourceRect.size.width = newWidth
  } else {
    let newHeight = sourceSize.width / destinationRatio
    sourceRect.origin.y = (sourceSize.height - newHeight) / 2
    sourceRect.size.height = newHeight
  }

  image.draw(in: destinationRect, from: sourceRect, operation: .sourceOver, fraction: 1)
}

let image = NSImage(size: canvasSize)
image.lockFocus()

guard let context = NSGraphicsContext.current?.cgContext else {
  fputs("Unable to create drawing context.\n", stderr)
  exit(1)
}

let gradient = CGGradient(
  colorsSpace: CGColorSpaceCreateDeviceRGB(),
  colors: [backgroundTop.cgColor, backgroundBottom.cgColor] as CFArray,
  locations: [0, 1]
)

context.drawLinearGradient(
  gradient!,
  start: CGPoint(x: 0, y: canvasSize.height),
  end: CGPoint(x: canvasSize.width, y: 0),
  options: []
)

let panelPath = NSBezierPath(roundedRect: panelRect, xRadius: 28, yRadius: 28)
panelFill.setFill()
panelPath.fill()
panelStroke.setStroke()
panelPath.lineWidth = 1
panelPath.stroke()

drawText(
  "Vitaliy\nStanyshevskyy",
  rect: NSRect(x: textLeft, y: 306, width: 560, height: 180),
  font: nameFont,
  color: nameColor,
  lineHeight: 72
)

drawText(
  "Engineering manager and product engineering lead",
  rect: NSRect(x: textLeft, y: 228, width: 520, height: 92),
  font: roleFont,
  color: mutedColor,
  lineHeight: 42
)

drawText(
  "Based in Copenhagen and open to remote and hybrid leadership opportunities.",
  rect: NSRect(x: textLeft, y: 126, width: 520, height: 96),
  font: metaFont,
  color: mutedColor,
  lineHeight: 34
)

drawText(
  "vistan.me",
  rect: NSRect(x: textLeft, y: 96, width: 180, height: 36),
  font: domainFont,
  color: nameColor
)

drawCroppedImage(portrait, in: photoRect, cornerRadius: 26)

let photoBorder = NSBezierPath(roundedRect: photoRect, xRadius: 26, yRadius: 26)
NSColor(calibratedWhite: 1, alpha: 0.9).setStroke()
photoBorder.lineWidth = 3
photoBorder.stroke()

image.unlockFocus()

guard
  let tiffData = image.tiffRepresentation,
  let bitmap = NSBitmapImageRep(data: tiffData),
  let pngData = bitmap.representation(using: .png, properties: [:])
else {
  fputs("Unable to encode PNG output.\n", stderr)
  exit(1)
}

try pngData.write(to: URL(fileURLWithPath: outputPath))
print("Generated \(outputPath)")
