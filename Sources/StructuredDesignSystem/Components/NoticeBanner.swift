import SwiftUI

/// 信息与警示提示通栏卡片（Structured 风格）
///
/// 严格遵循 20pt 浮岛圆角、浅色软底与 0.5pt 细微边缘高光，支持 4 种语义状态与动作触发。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：提示信息与按键文案必须由外部注入，组件内部不写死任何文案；
/// 2. 【语义状态对齐】：严格按 info / warning / error / neutral 四种规范分流，匹配对应强调色与标准图标；
/// 3. 【无二次透明稀释】：正文严格采用 `textPrimary`，在浅色软底上满足 WCAG 4.5:1 对比度。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// NoticeBanner(
///     style: .warning,
///     message: "banner_warning_duration",
///     actionTitle: "banner_action_trim"
/// ) {
///     trimVideo()
/// }
///
/// // 2. 动态非本地化错误信息（Verbatim 直出）
/// NoticeBanner(
///     style: .error,
///     verbatim: error.localizedDescription,
///     actionTitle: "Retry"
/// ) {
///     retry()
/// }
/// ```
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
    private let message: LocalizedText
    private let icon: String?
    private let actionTitle: LocalizedText?
    private let onAction: (() -> Void)?

    /// 本地化初始化器（Apple 原生风格）
    public init(
        style: Style = .info,
        _ message: LocalizedStringKey,
        icon: String? = nil,
        actionTitle: LocalizedStringKey? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.style = style
        self.message = .localized(message)
        self.icon = icon
        self.actionTitle = actionTitle.map { .localized($0) }
        self.onAction = onAction
    }

    /// 具名本地化初始化器
    public init(
        style: Style = .info,
        message: LocalizedStringKey,
        icon: String? = nil,
        actionTitle: LocalizedStringKey? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.init(style: style, message, icon: icon, actionTitle: actionTitle, onAction: onAction)
    }

    /// 动态非本地化直出初始化器
    public init(
        style: Style = .info,
        verbatim message: String,
        icon: String? = nil,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.style = style
        self.message = .verbatim(message)
        self.icon = icon
        self.actionTitle = actionTitle.map { .verbatim($0) }
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

            message.makeText()
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitle, let onAction {
                Button(action: {
                    HapticManager.impact(.light)
                    onAction()
                }) {
                    actionTitle.makeText()
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
