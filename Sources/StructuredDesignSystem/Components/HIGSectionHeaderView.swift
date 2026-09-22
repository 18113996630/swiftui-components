import SwiftUI

/// HIG 标准表单与分组标题视图（Structured 风格）
/// 包含微型彩色图标底座、SF Pro Rounded 粗体标题、可选的计数状态微标以及右侧操作插槽
public struct HIGSectionHeaderView<TrailingContent: View>: View {
    @Environment(\.themePalette) private var themePalette

    private let title: String
    private let icon: String?
    private let iconColor: Color?
    private let badgeText: String?
    private let trailing: TrailingContent

    public init(
        title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.badgeText = badgeText
        self.trailing = trailing()
    }

    private var effectiveIconColor: Color {
        iconColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            if let icon {
                IconBadge(
                    systemName: icon,
                    color: effectiveIconColor,
                    size: 22
                )
            }

            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Color.textPrimary)

            if let badgeText {
                PillBadge(title: badgeText, style: .subtle(effectiveIconColor))
            }

            Spacer()

            trailing
        }
        .padding(.horizontal, DesignSystem.Spacing.tiny)
        .padding(.vertical, DesignSystem.Spacing.tiny)
    }
}

public extension HIGSectionHeaderView where TrailingContent == EmptyView {
    init(
        title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil
    ) {
        self.init(
            title: title,
            icon: icon,
            iconColor: iconColor,
            badgeText: badgeText
        ) {
            EmptyView()
        }
    }
}

#Preview("HIGSectionHeaderView Demo") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HIGSectionHeaderView(
            title: "核心参数配置",
            icon: "slider.horizontal.3",
            badgeText: "已保存"
        ) {
            Button("重置") {}
                .font(DesignSystem.Typography.caption)
        }

        HIGSectionHeaderView(
            title: "分发渠道矩阵",
            icon: "arrow.triangle.branch",
            iconColor: .orange,
            badgeText: "3个启用"
        )
    }
    .padding()
    .themePalette(.teal)
}
