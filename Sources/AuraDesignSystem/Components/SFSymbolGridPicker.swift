import SwiftUI

/// SF Symbol 图标矩阵选择器（Aura 风格）
/// 严格遵循 14pt 连续圆角底座与主题光晕动画，支持单选与轻触反馈
public struct SFSymbolGridPicker: View {
    @Environment(\.themePalette) private var themePalette

    @Binding private var selectedSymbol: String
    private let symbols: [String]
    private let columnsCount: Int
    private let itemSize: CGFloat
    private let customTint: Color?

    public init(
        selectedSymbol: Binding<String>,
        symbols: [String],
        columns: Int = 5,
        itemSize: CGFloat = 46,
        tintColor: Color? = nil
    ) {
        self._selectedSymbol = selectedSymbol
        self.symbols = symbols
        self.columnsCount = columns
        self.itemSize = itemSize
        self.customTint = tintColor
    }

    private var effectiveTint: Color {
        customTint ?? themePalette.color
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: DesignSystem.Spacing.medium), count: columnsCount)
    }

    public var body: some View {
        LazyVGrid(columns: gridColumns, spacing: DesignSystem.Spacing.medium) {
            ForEach(symbols, id: \.self) { symbol in
                let isSelected = selectedSymbol == symbol

                Button(action: {
                    guard selectedSymbol != symbol else { return }
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                        selectedSymbol = symbol
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                            .fill(isSelected ? effectiveTint.opacity(0.18) : DesignSystem.Color.fillSecondary)

                        if isSelected {
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                                .strokeBorder(effectiveTint, lineWidth: 1.5)
                        }

                        Image(systemName: symbol)
                            .font(.system(size: itemSize * 0.42, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? effectiveTint : DesignSystem.Color.textPrimary)
                    }
                    .frame(height: itemSize)
                    .contentShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
                    .shadow(
                        color: isSelected ? effectiveTint.opacity(0.2) : Color.clear,
                        radius: 6,
                        x: 0,
                        y: 2
                    )
                }
                .buttonStyle(.scale)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("SFSymbolGridPicker Demo") {
    SFSymbolGridPreviewHelper()
}

private struct SFSymbolGridPreviewHelper: View {
    @State private var currentSymbol = "sparkles"

    let sampleSymbols = [
        "sparkles", "bolt.fill", "flame.fill", "heart.fill", "star.fill",
        "video.fill", "mic.fill", "camera.fill", "play.circle.fill", "waveform",
        "pencil", "text.quote", "doc.text.fill", "folder.fill", "tray.fill"
    ]

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Text("SFSymbolGridPicker (图标矩阵)")
                .font(DesignSystem.Typography.headline)

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        Text("选择功能标识")
                            .font(DesignSystem.Typography.headline)
                        Spacer()
                        Image(systemName: currentSymbol)
                            .foregroundColor(ThemePalette.indigo.color)
                    }

                    SFSymbolGridPicker(
                        selectedSymbol: $currentSymbol,
                        symbols: sampleSymbols
                    )
                }
            }
        }
        .padding()
        .themePalette(.indigo)
    }
}
