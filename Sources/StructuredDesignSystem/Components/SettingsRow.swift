import SwiftUI

/// 设置列表行（图标 + 标题 + 右侧指示器/专业版徽章）
public struct SettingsRow: View {
    private let icon: String
    private let iconColor: Color
    private let title: String
    private let showProBadge: Bool
    private let action: (() -> Void)?

    public init(
        icon: String,
        iconColor: Color,
        title: String,
        showProBadge: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.showProBadge = showProBadge
        self.action = action
    }

    public var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: DesignSystem.Layout.iconTextSpacing) {
                IconBadge(
                    systemName: icon,
                    color: iconColor,
                    size: DesignSystem.Iconography.sizeMedium
                )

                Text(title)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Spacer()

                if showProBadge {
                    Text("专业版")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(DesignSystem.Color.primary.opacity(0.1))
                        .foregroundColor(DesignSystem.Color.primary)
                        .cornerRadius(DesignSystem.CornerRadius.small)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
            .padding(.horizontal, DesignSystem.Layout.cardPadding)
            .background(DesignSystem.Color.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
