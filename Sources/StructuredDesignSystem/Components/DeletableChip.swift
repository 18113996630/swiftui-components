import SwiftUI

/// 带有删除功能的标签胶囊（Structured 风格）
/// 常用于已选话题标签（如 #职场干货）、自定义禁用词或分发渠道标签
public struct DeletableChip: View {
    @Environment(\.themePalette) private var themePalette

    private let title: String
    private let prefix: String?
    private let customColor: Color?
    private let onDelete: () -> Void

    public init(
        title: String,
        prefix: String? = "#",
        color: Color? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.title = title
        self.prefix = prefix
        self.customColor = color
        self.onDelete = onDelete
    }

    private var effectiveColor: Color {
        customColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: 5) {
            if let prefix {
                Text(prefix)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(effectiveColor)
                    .fontWeight(.bold)
            }

            Text(title)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .fontWeight(.medium)

            Button(action: {
                HapticManager.impact(.light)
                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                    onDelete()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Color.textTertiary)
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.leading, prefix != nil ? 10 : 12)
        .padding(.trailing, 4)
        .padding(.vertical, 4)
        .background(DesignSystem.Color.fillSecondary)
        .clipShape(Capsule())
        .contentShape(Capsule())
    }
}

#Preview("DeletableChip Demo") {
    DeletableChipPreviewHelper()
}

private struct DeletableChipPreviewHelper: View {
    @State private var tags = ["个人成长", "创业复盘", "高效提词", "AI赋能", "时间管理"]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text("DeletableChip (可删除标签)")
                .font(DesignSystem.Typography.headline)

            FlowLayout(horizontalSpacing: 8, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    DeletableChip(title: tag) {
                        tags.removeAll { $0 == tag }
                    }
                }
            }
        }
        .padding()
        .themePalette(.coral)
    }
}
