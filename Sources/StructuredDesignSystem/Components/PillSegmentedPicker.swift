import SwiftUI

/// 标杆级软底胶囊分段选择器（Structured 风格，支持 @Environment(\.themePalette)）
/// 彻底去除原生 UISegmentedControl 的硬金属反光，采用平滑滑块与触觉反馈
public struct PillSegmentedPicker<Selection: Hashable>: View {
    @Environment(\.themePalette) private var themePalette
    @Binding private var selection: Selection
    private let items: [Selection]
    private let titleForSelection: (Selection) -> String
    private let customActiveColor: Color?
    @Namespace private var animationNamespace

    public init(
        selection: Binding<Selection>,
        items: [Selection],
        activeColor: Color? = nil,
        titleForSelection: @escaping (Selection) -> String
    ) {
        self._selection = selection
        self.items = items
        self.customActiveColor = activeColor
        self.titleForSelection = titleForSelection
    }

    private var effectiveActiveColor: Color {
        customActiveColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(items, id: \.self) { item in
                let isSelected = selection == item

                Button(action: {
                    guard selection != item else { return }
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.76)) {
                        selection = item
                    }
                }) {
                    Text(titleForSelection(item))
                        .font(DesignSystem.Typography.headline)
                        .fontWeight(isSelected ? .semibold : .medium)
                        .foregroundColor(isSelected ? .white : DesignSystem.Color.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                                        .fill(effectiveActiveColor)
                                        .matchedGeometryEffect(id: "ActiveSegmentBackground", in: animationNamespace)
                                        .shadow(color: effectiveActiveColor.opacity(0.28), radius: 6, x: 0, y: 3)
                                }
                            }
                        )
                        .contentShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(DesignSystem.Color.fillTertiary)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button + 4, style: .continuous))
    }
}

// MARK: - Previews
#Preview("PillSegmentedPicker Preview") {
    PillSegmentedPickerPreviewHelper()
}

private struct PillSegmentedPickerPreviewHelper: View {
    enum ThemeMode: String, CaseIterable {
        case full = "完整"
        case light = "浅色"
        case dark = "深色"
    }

    @State private var selectedMode: ThemeMode = .full

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("外观主题")
                            .font(DesignSystem.Typography.headline)

                        PillSegmentedPicker(
                            selection: $selectedMode,
                            items: ThemeMode.allCases,
                            titleForSelection: { $0.rawValue }
                        )

                        Text("当前选择: \(selectedMode.rawValue)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
            .themePalette(.amber)
        }
    }
}
