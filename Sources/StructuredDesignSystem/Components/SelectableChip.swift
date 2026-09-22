import SwiftUI

/// 状态切换标签芯片（Structured 风格）
/// 支持单选/多选场景，选中态具备平滑 Spring 动效、勾选图标与触觉反馈
public struct SelectableChip: View {
    @Environment(\.themePalette) private var themePalette

    private let title: String
    private let isSelected: Bool
    private let icon: String?
    private let customTint: Color?
    private let onToggle: () -> Void

    public init(
        title: String,
        isSelected: Bool,
        icon: String? = nil,
        tintColor: Color? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.icon = icon
        self.customTint = tintColor
        self.onToggle = onToggle
    }

    private var effectiveTint: Color {
        customTint ?? themePalette.color
    }

    public var body: some View {
        Button(action: {
            HapticManager.selection()
            withAnimation(.spring(response: 0.25, dampingFraction: 0.72)) {
                onToggle()
            }
        }) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .transition(.scale.combined(with: .opacity))
                } else if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }

                Text(title)
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected ? effectiveTint : DesignSystem.Color.fillTertiary
            )
            .foregroundColor(
                isSelected ? .white : DesignSystem.Color.textPrimary
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
            .shadow(
                color: isSelected ? effectiveTint.opacity(0.25) : Color.clear,
                radius: 6,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(.scale)
    }
}

#Preview("SelectableChip Variations") {
    SelectableChipPreviewHelper()
}

private struct SelectableChipPreviewHelper: View {
    @State private var selected = Set(["短视频", "爆款脚本"])

    let tags = ["短视频", "爆款脚本", "带货提词", "AI改写", "宣发海报", "灵感速记"]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text("SelectableChip (可选择胶囊芯片)")
                .font(DesignSystem.Typography.headline)

            FlowLayout(horizontalSpacing: 8, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    SelectableChip(
                        title: tag,
                        isSelected: selected.contains(tag)
                    ) {
                        if selected.contains(tag) {
                            selected.remove(tag)
                        } else {
                            selected.insert(tag)
                        }
                    }
                }
            }
        }
        .padding()
        .themePalette(.teal)
    }
}
