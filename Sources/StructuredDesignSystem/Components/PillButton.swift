import SwiftUI

/// 胶囊状标签按钮（支持 @Environment(\.themePalette) 动态换肤）
///
/// 具备 0.97 物理微缩触感样式 (`ScaleButtonStyle`)，支持图标、主题强调色与自适应多巴胺背景。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：按钮自身不内置任何写死自然语言文案，由调用方显式传入；
/// 2. 【物理缩放触感】：强制绑定 `ScaleButtonStyle`，禁止替换为生硬无按压反馈的普通按钮；
/// 3. 【触觉反馈连贯】：点击时自动响应轻微触觉反馈。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// PillButton("action_create_script", icon: "plus") {
///     createNewScript()
/// }
///
/// // 2. 动态非本地化直出
/// PillButton(verbatim: "\(remainingTasks) left", icon: "checklist") {
///     viewRemaining()
/// }
/// ```
public struct PillButton: View {
    @Environment(\.themePalette) private var themePalette

    private let title: LocalizedText
    private let icon: String?
    private let customColor: Color?
    private let customBackground: Color?
    private let action: () -> Void

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        color: Color? = nil,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = .localized(title)
        self.icon = icon
        self.customColor = color
        self.customBackground = backgroundColor
        self.action = action
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        icon: String? = nil,
        color: Color? = nil,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.init(title, icon: icon, color: color, backgroundColor: backgroundColor, action: action)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        icon: String? = nil,
        color: Color? = nil,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = .verbatim(title)
        self.icon = icon
        self.customColor = color
        self.customBackground = backgroundColor
        self.action = action
    }

    private var activeColor: Color {
        customColor ?? themePalette.color
    }

    private var activeBackground: Color {
        customBackground ?? themePalette.tint
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.tiny) {
                if let icon {
                    Image(systemName: icon)
                }

                title.makeText()
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.small)
            .background(activeBackground)
            .foregroundColor(activeColor)
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview("PillButton States") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HStack(spacing: DesignSystem.Spacing.small) {
            PillButton("带图标标签", icon: "sparkles", action: {})
            PillButton("纯文本", action: {})
            PillButton(verbatim: "3/8", icon: "checklist", action: {})
        }

        HStack(spacing: DesignSystem.Spacing.small) {
            PillButton(
                title: "自定义珊瑚色",
                icon: "heart.fill",
                color: ThemePalette.coral.color,
                backgroundColor: ThemePalette.coral.tint,
                action: {}
            )
            PillButton(title: "快速同步", icon: "arrow.triangle.2.circlepath", action: {})
        }
    }
    .padding(DesignSystem.Layout.pagePadding)
    .themePalette(.indigo)
}
