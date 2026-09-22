#if os(macOS)
import SwiftUI
import AppKit
import AuraDesignSystem

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
        let outputDir = "/Users/huangrong/.antigravity-profile2/.gemini/antigravity/brain/86bd639e-2cd8-437b-bfdf-e64264701384"

        print("Rendering Document Home Specimen (Refined) - Light...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                DocumentHomeSpecimenView()
                    .themePalette(.indigo)
            },
            outputPath: "\(outputDir)/document_home_refined.png"
        )

        print("Rendering Document Home Specimen (Refined) - Dark...")
        render(
            view: DeviceFrameContainer(colorScheme: .dark) {
                DocumentHomeSpecimenView()
                    .themePalette(.indigo)
            },
            outputPath: "\(outputDir)/document_home_dark.png"
        )

        print("Rendering Document Home Specimen (Refined) - English...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                DocumentHomeSpecimenView(language: .english)
                    .themePalette(.indigo)
            },
            outputPath: "\(outputDir)/document_home_english.png"
        )

        print("Rendering Document Home Specimen (Refined) - German (Long Copy)...")
        render(
            view: DeviceFrameContainer(colorScheme: .light) {
                DocumentHomeSpecimenView(language: .german)
                    .themePalette(.indigo)
            },
            outputPath: "\(outputDir)/document_home_german.png"
        )

        print("Rendering Document Home Side-by-Side Comparison...")
        render(
            view: HStack(spacing: 24) {
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("原版现状（单字孤行 · 标签杂糅 · 纯黑底栏抢戏）")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 12)

                    DeviceFrameContainer(colorScheme: .light) {
                        DocumentHomeOriginalBuggyView()
                    }
                }

                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.indigo)
                        Text("标杆重构（舒展单行 · 规整微标 · 原生 iOS26 质感）")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 12)

                    DeviceFrameContainer(colorScheme: .light) {
                        DocumentHomeSpecimenView(language: .chinese)
                            .themePalette(.indigo)
                    }
                }
            }
            .padding(20)
            .background(Color(red: 0.93, green: 0.93, blue: 0.95)),
            frameSize: CGSize(width: 910, height: 950),
            outputPath: "\(outputDir)/document_home_comparison.png"
        )

        print("Rendering Document Home i18n Matrix (Chinese / English / German)...")
        render(
            view: HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("中文（标准字长 · 舒展对齐）")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    DeviceFrameContainer(colorScheme: .light) {
                        DocumentHomeSpecimenView(language: .chinese)
                            .themePalette(.indigo)
                    }
                }

                VStack(spacing: 8) {
                    Text("English（单词空格自适应）")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    DeviceFrameContainer(colorScheme: .light) {
                        DocumentHomeSpecimenView(language: .english)
                            .themePalette(.indigo)
                    }
                }

                VStack(spacing: 8) {
                    Text("Deutsch（复合超长词抗压测试）")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    DeviceFrameContainer(colorScheme: .light) {
                        DocumentHomeSpecimenView(language: .german)
                            .themePalette(.indigo)
                    }
                }
            }
            .padding(20)
            .background(Color(red: 0.93, green: 0.93, blue: 0.95)),
            frameSize: CGSize(width: 1350, height: 950),
            outputPath: "\(outputDir)/document_home_i18n_matrix.png"
        )

        print("All previews rendered successfully!")
    }

    @MainActor
    static func render<V: View>(view: V, frameSize: CGSize = CGSize(width: 421, height: 880), outputPath: String) {
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
