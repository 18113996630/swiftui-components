import SwiftUI

/// Aura 微光设计系统标准段落分组容器
///
/// 自动集成 `HIGSectionHeaderView` 头部标杆（包含微型彩色图标底座、SF Pro Rounded 粗体标题、
/// 可选计数微标以及右侧操作插槽），并强制约束段落头部与卡片内容的 12pt 内间隔。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【段落骨架定调】：章节段落必须使用 `AuraSection` 包装，自动采用 `Color.primary` 撑起黑白骨架，严禁将章节大标裸露设为发虚淡灰色；
/// 2. 【内容入仓】：段落内容槽位（Content）必须使用 `BaseCard` 组装结构，禁止长段正文裸露在冷灰底板上；
/// 3. 【主题色点睛】：图标底座默认继承 `@Environment(\.themePalette)`，达成多巴胺色彩与黑白骨架的 20/80 黄金比例。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// AuraSection("section_core_tasks", icon: "sparkles", badgeText: "today_badge") {
///     BaseCard {
///         Text("card_content").font(DesignSystem.Typography.headline)
///     }
/// }
///
/// // 2. 动态非本地化直出
/// AuraSection(verbatim: dynamicCategory.name, icon: "folder") {
///     BaseCard { ... }
/// }
/// ```
public struct AuraSection<Content: View, Trailing: View>: View {
    private let title: LocalizedText
    private let icon: String?
    private let iconColor: Color?
    private let badgeText: LocalizedText?
    private let trailing: Trailing
    private let content: Content

    /// 本地化初始化器（Apple 原生风格，支持 Xcode 自动抓取）
    public init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: LocalizedStringKey? = nil,
        badgeVerbatim: String? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.title = .localized(title)
        self.icon = icon
        self.iconColor = iconColor
        if let badgeText {
            self.badgeText = .localized(badgeText)
        } else if let badgeVerbatim {
            self.badgeText = .verbatim(badgeVerbatim)
        } else {
            self.badgeText = nil
        }
        self.trailing = trailing()
        self.content = content()
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: LocalizedStringKey? = nil,
        badgeVerbatim: String? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title, icon: icon, iconColor: iconColor, badgeText: badgeText, badgeVerbatim: badgeVerbatim, trailing: trailing, content: content)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.title = .verbatim(title)
        self.icon = icon
        self.iconColor = iconColor
        self.badgeText = badgeText.map { .verbatim($0) }
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

public extension AuraSection where Trailing == EmptyView {
    init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: LocalizedStringKey? = nil,
        badgeVerbatim: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title,
            icon: icon,
            iconColor: iconColor,
            badgeText: badgeText,
            badgeVerbatim: badgeVerbatim,
            trailing: { EmptyView() },
            content: content
        )
    }

    init(
        title: LocalizedStringKey,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: LocalizedStringKey? = nil,
        badgeVerbatim: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title,
            icon: icon,
            iconColor: iconColor,
            badgeText: badgeText,
            badgeVerbatim: badgeVerbatim,
            trailing: { EmptyView() },
            content: content
        )
    }

    init(
        verbatim title: String,
        icon: String? = nil,
        iconColor: Color? = nil,
        badgeText: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            verbatim: title,
            icon: icon,
            iconColor: iconColor,
            badgeText: badgeText,
            trailing: { EmptyView() },
            content: content
        )
    }
}

@available(*, deprecated, renamed: "AuraSection")
public typealias StructuredSection = AuraSection

#Preview("AuraSection Demo") {
    VStack(spacing: DesignSystem.Spacing.large) {
        AuraSection(
            "日程规划",
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
