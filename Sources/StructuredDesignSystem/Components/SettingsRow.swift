import SwiftUI

/// Structured 标杆风格设置与表单列表行
///
/// 贴合 HIG 标准：微型彩色图标底座 + 标题/辅助解释副标题 + 泛型右侧控件插槽（Toggle、导航指示器、自定义微标等）。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【主次对比度】：标题为 `headline` (Semibold)，副标题为 `caption` 并采用 `textSecondary`，满足 WCAG 4.5:1 基准；
/// 2. 【卡片封装】：设置行应作为 `BaseCard` 内的列表项组织，多行之间使用 `.opacity(0.4)` 的 Divider 分割；
/// 3. 【可点击反馈】：当传入 `action` 时，整行自动具备 Scale 与 Haptic 微触感反馈；
/// 4. 【严禁内置文案】：组件内不内置任何写死文案（如“专业版”），徽标等文本由调用方通过 `badgeText` 自行指定。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// SettingsRow(
///     icon: "bell.badge.fill",
///     iconColor: .orange,
///     title: "settings_notification_title",
///     subtitle: "settings_notification_subtitle",
///     badgeText: "PRO"
/// ) {
///     print("Tapped")
/// }
///
/// // 2. 开关切换行
/// SettingsRow.toggle(
///     icon: "moon.fill",
///     iconColor: .indigo,
///     title: "settings_dnd_title",
///     isOn: $isDndEnabled
/// )
/// ```
public struct SettingsRow<TrailingContent: View>: View {
    private let icon: String?
    private let iconColor: Color
    private let title: LocalizedText
    private let subtitle: LocalizedText?
    private let action: (() -> Void)?
    private let trailing: TrailingContent

    /// 本地化初始化器（Apple 原生风格）
    public init(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = .localized(title)
        self.subtitle = subtitle.map { .localized($0) }
        self.action = action
        self.trailing = trailing()
    }

    /// 具名本地化初始化器
    public init(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.init(icon: icon, iconColor: iconColor, title, subtitle: subtitle, action: action, trailing: trailing)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = .verbatim(title)
        self.subtitle = subtitle.map { .verbatim($0) }
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
                title.makeText()
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                if let subtitle {
                    subtitle.makeText()
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

// MARK: - 便捷重载与通用微标
public extension SettingsRow where TrailingContent == AnyView {
    /// 带有可选徽标与导航指示器的本地化初始化器（Apple 原生风格）
    init(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        badgeText: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        let localizedBadge = badgeText.map { LocalizedText.localized($0) }
        self.init(
            icon: icon,
            iconColor: iconColor,
            title,
            subtitle: subtitle,
            action: action
        ) {
            AnyView(
                Group {
                    if let localizedBadge {
                        localizedBadge.makeText()
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(iconColor.opacity(0.12))
                            .foregroundColor(iconColor)
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

    /// 具名本地化初始化器
    init(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        badgeText: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            icon: icon,
            iconColor: iconColor,
            title,
            subtitle: subtitle,
            badgeText: badgeText,
            action: action
        )
    }

    /// 动态非本地化直出初始化器
    init(
        verbatim title: String,
        subtitle: String? = nil,
        badgeText: String? = nil,
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        action: (() -> Void)? = nil
    ) {
        let verbatimBadge = badgeText.map { LocalizedText.verbatim($0) }
        self.init(
            verbatim: title,
            subtitle: subtitle,
            icon: icon,
            iconColor: iconColor,
            action: action
        ) {
            AnyView(
                Group {
                    if let verbatimBadge {
                        verbatimBadge.makeText()
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(iconColor.opacity(0.12))
                            .foregroundColor(iconColor)
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

    /// 向后兼容接口（弃用特定 ProBadge，引导使用通用 badgeText）
    @available(*, deprecated, message: "Use badgeText: LocalizedStringKey? instead to avoid hardcoded copy")
    init(
        icon: String,
        iconColor: Color = DesignSystem.Color.primary,
        title: String,
        subtitle: String? = nil,
        showProBadge: Bool,
        action: (() -> Void)? = nil
    ) {
        self.init(
            verbatim: title,
            subtitle: subtitle,
            badgeText: showProBadge ? "PRO" : nil,
            icon: icon,
            iconColor: iconColor,
            action: action
        )
    }

    /// 开关切换配置行 (Toggle - LocalizedStringKey)
    static func toggle(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        isOn: Binding<Bool>
    ) -> SettingsRow<AnyView> {
        SettingsRow<AnyView>(
            icon: icon,
            iconColor: iconColor,
            title,
            subtitle: subtitle,
            action: nil
        ) {
            AnyView(
                Toggle(isOn: isOn) { EmptyView() }
                    .labelsHidden()
            )
        }
    }

    /// 开关切换配置行 (Toggle - 具名 LocalizedStringKey)
    static func toggle(
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        isOn: Binding<Bool>
    ) -> SettingsRow<AnyView> {
        toggle(icon: icon, iconColor: iconColor, title, subtitle: subtitle, isOn: isOn)
    }

    /// 开关切换配置行 (Toggle - Verbatim String)
    static func toggle(
        verbatim title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = DesignSystem.Color.primary,
        isOn: Binding<Bool>
    ) -> SettingsRow<AnyView> {
        SettingsRow<AnyView>(
            verbatim: title,
            subtitle: subtitle,
            icon: icon,
            iconColor: iconColor,
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
                        badgeText: "PRO"
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
