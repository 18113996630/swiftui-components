import SwiftUI

/// HIG 标准表单与分组标题视图（Structured 风格）
///
/// 包含微型彩色图标底座、SF Pro Rounded 粗体标题、可选计数微标以及右侧操作插槽。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【标题黑白骨架】：章节标题内部强制使用 `DesignSystem.Color.textPrimary`，严禁将其降维为发虚的淡灰色；
/// 2. 【多巴胺底座】：图标底座默认提取当前 `@Environment(\.themePalette)`，起到画龙点睛的 20% 色彩提亮作用；
/// 3. 【推荐包装】：推荐优先使用 `StructuredSection` 容器组合，自动管理与下属卡片之间的 12pt 内边距。
///
/// ```swift
/// HIGSectionHeaderView(
///     title: "核心参数配置",
///     icon: "slider.horizontal.3",
///     badgeText: "已保存"
/// ) {
///     Button("重置") {}
///         .font(DesignSystem.Typography.caption)
/// }
/// ```
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
