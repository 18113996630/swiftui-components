#if os(macOS)
import SwiftUI
import AppKit
import StructuredDesignSystem

struct DeviceFrameContainer<Content: View>: View {
    let colorScheme: ColorScheme
    let content: Content

    init(colorScheme: ColorScheme, @ViewBuilder content: () -> Content) {
        self.colorScheme = colorScheme
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Background
            (colorScheme == .dark ? Color.black : Color(red: 0.949, green: 0.949, blue: 0.969))
                .ignoresSafeArea()

            // View Content with Top Safe Area
            content
                .padding(.top, 48)
                .frame(width: 393, height: 852)
                .clipped()

            // Status Bar
            HStack {
                Text("9:41")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.leading, 32)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "cellularbars")
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.trailing, 30)
            }
            .padding(.top, 16)

            // Dynamic Island
            Capsule()
                .fill(Color.black)
                .frame(width: 122, height: 34)
                .padding(.top, 11)
        }
        .frame(width: 393, height: 852)
        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(
                    colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.85),
                    lineWidth: 5
                )
        )
        .padding(14)
        .background(colorScheme == .dark ? Color(red: 0.06, green: 0.06, blue: 0.07) : Color(red: 0.91, green: 0.91, blue: 0.93))
        .preferredColorScheme(colorScheme)
        .environment(\.colorScheme, colorScheme)
    }
}

@main
struct RenderPreviewsApp {
    @MainActor
    static func main() {
        let outputDir = "/Users/huangrong/.antigravity-profile2/.gemini/antigravity/brain/56110305-ea62-42fe-a1b2-eb1e55539e97"

        print("Rendering Typography Specimen - Light...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                TypographyShowcaseView()
            },
            outputPath: "\(outputDir)/typography_specimen_light.png"
        )

        print("Rendering Typography Specimen - Dark...")
        render(
            view: DeviceFrameContainer(colorScheme: .dark) {
                TypographyShowcaseView()
            },
            outputPath: "\(outputDir)/typography_specimen_dark.png"
        )

        print("Rendering Gallery View (Refreshed) - Light...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                DesignSystemGalleryView()
            },
            outputPath: "\(outputDir)/gallery_refreshed_light.png"
        )

        print("Rendering Gallery View (Refreshed) - Dark...")
        render(
            view: DeviceFrameContainer(colorScheme: .dark) {
                DesignSystemGalleryView()
            },
            outputPath: "\(outputDir)/gallery_refreshed_dark.png"
        )

        print("Rendering Scaffold Showcase - Light...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                ScaffoldShowcaseView()
            },
            outputPath: "\(outputDir)/scaffold_showcase_light.png"
        )

        print("Rendering Scaffold Showcase - Dark...")
        render(
            view: DeviceFrameContainer(colorScheme: .dark) {
                ScaffoldShowcaseView()
            },
            outputPath: "\(outputDir)/scaffold_showcase_dark.png"
        )

        print("All previews rendered successfully!")
    }

    @MainActor
    static func render<V: View>(view: V, outputPath: String) {
        let frameSize = CGSize(width: 421, height: 880)
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(origin: .zero, size: frameSize)

        let window = NSWindow(
            contentRect: CGRect(origin: .zero, size: frameSize),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.isReleasedWhenClosed = false
        window.display()
        hostingView.layoutSubtreeIfNeeded()

        let scale: CGFloat = 2.0
        let pixelWidth = Int(frameSize.width * scale)
        let pixelHeight = Int(frameSize.height * scale)
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: pixelWidth,
            pixelsHigh: pixelHeight,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            print("Failed to allocate bitmap rep")
            return
        }
        rep.size = frameSize

        NSGraphicsContext.saveGraphicsState()
        let context = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.current = context
        hostingView.displayIgnoringOpacity(hostingView.bounds, in: context!)
        NSGraphicsContext.restoreGraphicsState()

        if let pngData = rep.representation(using: .png, properties: [:]) {
            try? pngData.write(to: URL(fileURLWithPath: outputPath))
            print("Saved: \(outputPath) (\(pngData.count) bytes, \(pixelWidth)x\(pixelHeight))")
        } else {
            print("Failed to save: \(outputPath)")
        }
    }
}
#else
@main
struct RenderStub {
    static func main() {}
}
#endif
