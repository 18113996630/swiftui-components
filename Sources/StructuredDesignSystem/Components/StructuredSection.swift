import SwiftUI

/// Structured 标杆风格标准段落分组容器
///
/// 自动集成 `HIGSectionHeaderView` 头部标杆（包含微型彩色图标底座、SF Pro Rounded 粗体标题、
/// 可选计数微标以及右侧操作插槽），并强制约束段落头部与卡片内容的 12pt 内间隔。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【段落骨架定调】：章节段落必须使用 `StructuredSection` 包装，自动采用 `Color.primary` 撑起黑白骨架，严禁将章节大标裸露设为发虚淡灰色；
/// 2. 【内容入仓】：段落内容槽位（Content）必须使用 `BaseCard` 组装结构，禁止长段正文裸露在冷灰底板上；
/// 3. 【主题色点睛】：图标底座默认继承 `@Environment(\.themePalette)`，达成多巴胺色彩与黑白骨架的 20/80 黄金比例。
///
/// ```swift
/// StructuredSection(
///     title: "核心任务",
///     icon: "sparkles",
///     badgeText: "今天"
/// ) {
///     BaseCard {
///         TimelineTaskRow(...)
///     }
/// }
/// ```
public struct StructuredSection<Content: View, Trailing: View>: View {
    private let title: String
    private let icon: String?
    private let iconColor: Color?
    private let badgeText: String?
    private let trailing: Trailing
    private let content: Content

    public init(
        title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.badgeText = badgeText
        self.trailing = trailing()
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HIGSectionHeaderView(
                title: title,
                icon: icon,
                iconColor: iconColor,
                badgeText: badgeText
            ) {
                trailing
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public extension StructuredSection where Trailing == EmptyView {
    init(
        title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title: title,
            icon: icon,
            iconColor: iconColor,
            badgeText: badgeText,
            trailing: { EmptyView() },
            content: content
        )
    }
}

#Preview("StructuredSection Demo") {
    VStack(spacing: DesignSystem.Spacing.large) {
        StructuredSection(
            title: "日程规划",
            icon: "calendar",
            badgeText: "3 项未完成"
        ) {
            Button("查看更多") {}
                .font(DesignSystem.Typography.caption)
        } content: {
            BaseCard {
                Text("待办事项列表卡片")
                    .font(DesignSystem.Typography.headline)
            }
        }
    }
    .padding()
    .themePalette(.orange)
}
