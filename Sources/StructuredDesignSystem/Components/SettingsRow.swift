import SwiftUI

/// 设置与配置列表行（Structured 风格）
/// 严格贴合 HIG 标准：微型彩色图标底座 + 标题/辅助解释副标题 + 泛型右侧控件插槽（Toggle、指示器、专业版徽标等）
public struct SettingsRow<TrailingContent: View>: View {
    private let icon: String?
    private let iconColor: Color
    private let title: String
    private let subtitle: String?
    private let action: (() -> Void)?
    private let trailing: TrailingContent

    public init(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        title: String,
        subtitle: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.trailing = trailing()
    }

    public var body: some View {
        let rowContent = HStack(spacing: DesignSystem.Layout.iconTextSpacing) {
            if let icon {
                IconBadge(
                    systemName: icon,
                    color: iconColor,
                    size: DesignSystem.Iconography.sizeMedium
                )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }
            }

            Spacer()

            trailing
        }
        .padding(.vertical, DesignSystem.Spacing.medium)
        .padding(.horizontal, DesignSystem.Layout.cardPadding)
        .background(DesignSystem.Color.cardBackground)
        .contentShape(Rectangle())

        Group {
            if let action {
                Button(action: {
                    HapticManager.impact(.light)
                    action()
                }) {
                    rowContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                rowContent
            }
        }
    }
}

// MARK: - 向后兼容与便捷重载
public extension SettingsRow where TrailingContent == AnyView {
    /// 向后兼容的默认导航箭头或专业版徽章行
    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String? = nil,
        showProBadge: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.init(
            icon: icon,
            iconColor: iconColor,
            title: title,
            subtitle: subtitle,
            action: action
        ) {
            AnyView(
                Group {
                    if showProBadge {
                        Text("专业版")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(DesignSystem.Color.primary.opacity(0.12))
                            .foregroundColor(DesignSystem.Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small, style: .continuous))
                    } else if action != nil {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    } else {
                        EmptyView()
                    }
                }
            )
        }
    }

    /// 开关切换配置行 (Toggle)
    static func toggle(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) -> SettingsRow<AnyView> {
        SettingsRow<AnyView>(
            icon: icon,
            iconColor: iconColor,
            title: title,
            subtitle: subtitle,
            action: nil
        ) {
            AnyView(
                Toggle(isOn: isOn) { EmptyView() }
                    .labelsHidden()
            )
        }
    }
}

#Preview("SettingsRow Group") {
    SettingsRowPreviewHelper()
}

private struct SettingsRowPreviewHelper: View {
    @State private var isPushEnabled = true

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "bell.fill",
                        iconColor: .red,
                        title: "通知与提醒",
                        subtitle: "每日早晨自动推送今日计划"
                    ) {
                        print("点击了通知")
                    }

                    Divider().padding(.leading, 56)

                    SettingsRow.toggle(
                        icon: "moon.fill",
                        iconColor: .indigo,
                        title: "专注模式联动",
                        subtitle: "进入日程时自动开启免打扰",
                        isOn: $isPushEnabled
                    )

                    Divider().padding(.leading, 56)

                    SettingsRow(
                        icon: "sparkles",
                        iconColor: DesignSystem.Color.primary,
                        title: "高级会员特权",
                        showProBadge: true
                    ) {
                        print("点击了会员")
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
                .shadow(
                    color: DesignSystem.Shadow.light.color,
                    radius: DesignSystem.Shadow.light.radius,
                    x: DesignSystem.Shadow.light.x,
                    y: DesignSystem.Shadow.light.y
                )
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
    }
}
