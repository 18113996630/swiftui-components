import SwiftUI

/// 标杆级系统微标（Aura 风格，只读展示型）
///
/// 专用于展示状态、分类标签、计数徽标或进度提示，与交互型 `PillButton` 形成互补。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【严禁内置文案】：微标自身不包含任何预设业务文案，所有展示文本由业务方显式传入；
/// 2. 【状态优先语义色】：状态表达应首选搭配 `IconBadge` 或对应语义色（如 amber 进行中 / sage 完成）；
/// 3. 【无二次透明稀释】：文字在 subtle / solid / neutral 模式下严格对齐 WCAG 4.5:1 对比度标准；
/// 4. 【轻量退让约束 (Subdued Footprint)】：微标文字采用 HIG Caption（12pt Semibold），配合 8x3 紧凑内边距，保证辅助元数据不抢夺正文与主标题权重。
///
/// ```swift
/// // 本地化字面量（Xcode 自动提取）
/// PillBadge("badge_in_progress", icon: "bolt.fill", style: .subtle(ThemePalette.amber.color))
///
/// // 动态运行时直出
/// PillBadge(verbatim: "\(count) items", style: .neutral)
/// ```
public struct PillBadge: View {
    @Environment(\.themePalette) private var themePalette

    public enum Style {
        case subtle(Color? = nil) // 15% 浅透明软底 + 强调色文字 (默认取主题色)
        case solid(Color? = nil)  // 饱满色彩背景 + 白色高对比文字 (默认取主题色)
        case neutral              // 系统级灰底 (tertiarySystemFill) + 次级灰文字
    }

    private let title: LocalizedText
    private let icon: String?
    private let style: Style

    /// 本地化初始化器（Apple 原生风格，支持 Xcode 自动抓取）
    public init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        style: Style = .subtle(nil)
    ) {
        self.title = .localized(title)
        self.icon = icon
        self.style = style
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        icon: String? = nil,
        style: Style = .subtle(nil)
    ) {
        self.init(title, icon: icon, style: style)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        icon: String? = nil,
        style: Style = .subtle(nil)
    ) {
        self.title = .verbatim(title)
        self.icon = icon
        self.style = style
    }

    /// 内部通用容器初始化器
    internal init(
        text: LocalizedText,
        icon: String? = nil,
        style: Style = .subtle(nil)
    ) {
        self.title = text
        self.icon = icon
        self.style = style
    }

    private var backgroundColor: Color {
        switch style {
        case .subtle(let customColor):
            return (customColor ?? themePalette.color).opacity(0.15)
        case .solid(let customColor):
            return customColor ?? themePalette.color
        case .neutral:
            return DesignSystem.Color.fillTertiary
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .subtle(let customColor):
            return customColor ?? themePalette.color
        case .solid:
            return .white
        case .neutral:
            return DesignSystem.Color.textSecondary
        }
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.tiny) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }

            title.makeText()
                .font(DesignSystem.Typography.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
    }
}

#Preview("PillBadge Styles") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HStack(spacing: DesignSystem.Spacing.small) {
            PillBadge("进行中", icon: "bolt.fill", style: .subtle(ThemePalette.amber.color))
            PillBadge(title: "已完成", icon: "checkmark", style: .subtle(ThemePalette.sage.color))
            PillBadge(verbatim: "ARCHIVED", style: .neutral)
        }

        HStack(spacing: DesignSystem.Spacing.small) {
            PillBadge(title: "PRO 会员", icon: "crown.fill", style: .solid(ThemePalette.coral.color))
            PillBadge(title: "默认主题软底", icon: "sparkles")
            PillBadge(verbatim: "9 Items", style: .subtle(.blue))
        }
    }
    .padding(DesignSystem.Layout.pagePadding)
    .themePalette(.indigo)
}
