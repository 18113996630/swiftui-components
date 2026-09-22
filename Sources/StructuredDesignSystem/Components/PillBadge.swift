import SwiftUI

/// 标杆级系统微标（Structured 风格，只读展示型）
/// 专用于展示状态、分类标签、计数徽标或进度提示，与交互型 `PillButton` 形成互补
public struct PillBadge: View {
    @Environment(\.themePalette) private var themePalette

    public enum Style {
        case subtle(Color? = nil) // 15% 浅透明软底 + 强调色文字 (默认取主题色)
        case solid(Color? = nil)  // 饱满色彩背景 + 白色高对比文字 (默认取主题色)
        case neutral              // 系统级灰底 (tertiarySystemFill) + 次级灰文字
    }

    private let title: String
    private let icon: String?
    private let style: Style

    public init(
        title: String,
        icon: String? = nil,
        style: Style = .subtle(nil)
    ) {
        self.title = title
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
            return Color(uiColor: .tertiarySystemFill)
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
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
            }

            Text(title)
                .font(DesignSystem.Typography.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
    }
}

#Preview("PillBadge Styles") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HStack(spacing: DesignSystem.Spacing.small) {
            PillBadge(title: "进行中", icon: "bolt.fill", style: .subtle(ThemePalette.amber.color))
            PillBadge(title: "已完成", icon: "checkmark", style: .subtle(ThemePalette.sage.color))
            PillBadge(title: "已归档", style: .neutral)
        }

        HStack(spacing: DesignSystem.Spacing.small) {
            PillBadge(title: "PRO 会员", icon: "crown.fill", style: .solid(ThemePalette.coral.color))
            PillBadge(title: "默认主题软底", icon: "sparkles")
            PillBadge(title: "9 组", style: .subtle(.blue))
        }
    }
    .padding(DesignSystem.Layout.pagePadding)
    .themePalette(.indigo)
}
