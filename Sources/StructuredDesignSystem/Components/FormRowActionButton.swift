import SwiftUI

/// 表单居中功能与破坏性操作按钮（Structured 风格）
///
/// 常用于卡片底部的“测试连通性”、“重置默认配置”、“清空所有历史”等关键动作。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：操作按键文案必须由业务方传入，严禁组件内部写死；
/// 2. 【破坏性操作警示】：`role: .destructive` 强制绑定红色视觉警示与 `HapticManager.notification(.warning)` 强反馈；
/// 3. 【表单全宽对齐】：内部采用 `.frame(maxWidth: .infinity)` 居中对齐，置于 `BaseCard` 底部形成收拢视觉。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动抓取）
/// FormRowActionButton("action_test_connection", icon: "arrow.triangle.2.circlepath") {
///     testConnection()
/// }
///
/// // 2. 危险破坏性动作
/// FormRowActionButton("action_reset_defaults", icon: "arrow.counterclockwise", role: .destructive) {
///     resetDefaults()
/// }
/// ```
public struct FormRowActionButton: View {
    @Environment(\.themePalette) private var themePalette

    public enum Role {
        case regular       // 主题色强调
        case destructive   // 警示红色
    }

    private let title: LocalizedText
    private let icon: String?
    private let role: Role
    private let action: () -> Void

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        role: Role = .regular,
        action: @escaping () -> Void
    ) {
        self.title = .localized(title)
        self.icon = icon
        self.role = role
        self.action = action
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        icon: String? = nil,
        role: Role = .regular,
        action: @escaping () -> Void
    ) {
        self.init(title, icon: icon, role: role, action: action)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        icon: String? = nil,
        role: Role = .regular,
        action: @escaping () -> Void
    ) {
        self.title = .verbatim(title)
        self.icon = icon
        self.role = role
        self.action = action
    }

    private var activeColor: Color {
        switch role {
        case .regular:
            return themePalette.color
        case .destructive:
            return SwiftUI.Color.red
        }
    }

    public var body: some View {
        Button(action: {
            if role == .destructive {
                HapticManager.notification(.warning)
            } else {
                HapticManager.impact(.light)
            }
            action()
        }) {
            HStack(spacing: DesignSystem.Spacing.small) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }

                title.makeText()
                    .font(DesignSystem.Typography.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(activeColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(activeColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
        }
        .buttonStyle(.scale)
    }
}

#Preview("FormRowActionButton Preview") {
    VStack(spacing: DesignSystem.Spacing.large) {
        BaseCard {
            VStack(spacing: DesignSystem.Spacing.medium) {
                FormRowActionButton(
                    "重新测试服务连通性",
                    icon: "arrow.triangle.2.circlepath",
                    role: .regular
                ) {}

                FormRowActionButton(
                    title: "恢复默认提示词预设",
                    icon: "arrow.counterclockwise",
                    role: .destructive
                ) {}
            }
        }
    }
    .padding()
    .themePalette(.teal)
}
