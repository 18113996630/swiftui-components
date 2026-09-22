import SwiftUI

/// 信息与警示提示通栏卡片（Structured 风格）
/// 严格遵循 20pt 浮岛圆角、浅色软底与 0.5pt 细微边缘高光，支持 4 种语义状态与动作触发
public struct NoticeBanner: View {
    @Environment(\.themePalette) private var themePalette

    public enum Style {
        case info
        case warning
        case error
        case neutral

        var defaultIcon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.octagon.fill"
            case .neutral: return "bell.fill"
            }
        }
    }

    private let style: Style
    private let message: String
    private let icon: String?
    private let actionTitle: String?
    private let onAction: (() -> Void)?

    public init(
        style: Style = .info,
        message: String,
        icon: String? = nil,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.style = style
        self.message = message
        self.icon = icon
        self.actionTitle = actionTitle
        self.onAction = onAction
    }

    private var accentColor: Color {
        switch style {
        case .info:
            return themePalette.color
        case .warning:
            return ThemePalette.orange.color
        case .error:
            return SwiftUI.Color.red
        case .neutral:
            return DesignSystem.Color.textSecondary
        }
    }

    public var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.medium) {
            Image(systemName: icon ?? style.defaultIcon)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(accentColor)

            Text(message)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitle, let onAction {
                Button(action: {
                    HapticManager.impact(.light)
                    onAction()
                }) {
                    Text(actionTitle)
                        .font(DesignSystem.Typography.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.scale)
            }
        }
        .padding(.horizontal, DesignSystem.Layout.cardPadding)
        .padding(.vertical, DesignSystem.Spacing.large)
        .background(accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                .strokeBorder(accentColor.opacity(0.2), lineWidth: 0.5)
        )
    }
}

#Preview("NoticeBanner Variations") {
    VStack(spacing: DesignSystem.Spacing.medium) {
        NoticeBanner(
            style: .info,
            message: "渠道宣发规则已更新，建议重新生成文案",
            actionTitle: "立即查看",
            onAction: {}
        )

        NoticeBanner(
            style: .warning,
            message: "视频时长超过平台限制（60s），可能影响曝光",
            actionTitle: "智能裁剪",
            onAction: {}
        )

        NoticeBanner(
            style: .error,
            message: "小红书链接解析失败，请检查网络后重试",
            actionTitle: "重试",
            onAction: {}
        )
    }
    .padding()
    .themePalette(.teal)
}
