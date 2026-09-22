import SwiftUI

/// 表单居中功能与破坏性操作按钮（Structured 风格）
/// 常用于卡片底部的“测试连通性”、“重置默认配置”、“清空所有历史”等关键动作
public struct FormRowActionButton: View {
    @Environment(\.themePalette) private var themePalette

    public enum Role {
        case regular       // 主题色强调
        case destructive   // 警示红色
    }

    private let title: String
    private let icon: String?
    private let role: Role
    private let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        role: Role = .regular,
        action: @escaping () -> Void
    ) {
        self.title = title
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

                Text(title)
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
                    title: "重新测试服务连通性",
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
