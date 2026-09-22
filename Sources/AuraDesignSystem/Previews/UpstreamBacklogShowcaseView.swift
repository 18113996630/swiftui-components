import SwiftUI

/// 回补组件专项全景展示视图（Upstream Components Specimen）
/// 集中展示本次从业务层回补到官方库的全新组件与初始化器重载：
/// 1. ClearableSecureFieldRow（密文输入行、明密文一键切换与轻触反馈）
/// 2. SettingsRow verbatimSubtitle（主标本地化 + 副标动态统计直出）
/// 3. ToastHUD 可选值驱动修饰符（Binding<LocalizedStringKey?> 自动延时消隐）
public struct UpstreamBacklogShowcaseView: View {
    @State private var secretKey = "sk-aura-99281-live-production"
    @State private var pinCode = "889922"
    @State private var isAssistantEnabled = true
    @State private var toastMessage: LocalizedStringKey? = nil
    @State private var selectedTheme: ThemePalette = .teal

    public init() {}

    public var body: some View {
        AuraScaffold {
            headerSection
            secureFieldSection
            settingsRowSection
            toastHUDSection
        }
        .themePalette(selectedTheme)
        .toastHUD(message: $toastMessage, icon: "sparkles", iconColor: selectedTheme.color)
    }

    // MARK: - 01 标头
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Text("回补组件专项")
                    .font(DesignSystem.Typography.largeTitle)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.merge")
                    Text("Upstream Backlog")
                }
                .font(DesignSystem.Typography.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(selectedTheme.color.opacity(0.15))
                .foregroundColor(selectedTheme.color)
                .clipShape(Capsule())
            }

            Text("业务层沉淀组件回补入库：密文输入、动态统计副标题直出与可选值驱动轻提示")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textSecondary)
        }
    }

    // MARK: - 02 ClearableSecureFieldRow
    private var secureFieldSection: some View {
        AuraSection("密文输入行 (ClearableSecureFieldRow)", icon: "key.horizontal.fill") {
            BaseCard {
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ClearableSecureFieldRow(
                        "访问密钥",
                        placeholder: "填写以 sk- 开头的密钥",
                        text: $secretKey,
                        allowReveal: true
                    )

                    Divider()

                    ClearableSecureFieldRow(
                        title: "支付密码",
                        placeholder: "6 位数字密码",
                        text: $pinCode,
                        allowReveal: false,
                        showPasteButton: true
                    )
                }
            }
        }
    }

    // MARK: - 03 SettingsRow verbatimSubtitle
    private var settingsRowSection: some View {
        AuraSection("动态副标题直出 (SettingsRow verbatimSubtitle)", icon: "text.badge.plus") {
            BaseCard(padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "server.rack",
                        iconColor: selectedTheme.color,
                        title: "本地智能缓存",
                        verbatimSubtitle: "已占用 128.4 MB (32 项)"
                    )

                    Divider().padding(.leading, 56)

                    SettingsRow.toggle(
                        icon: "sparkles",
                        iconColor: ThemePalette.berry.color,
                        title: "AI 实时纠偏",
                        verbatimSubtitle: isAssistantEnabled ? "2 项规则已激活生效" : "未开启",
                        isOn: $isAssistantEnabled
                    )
                }
            }
        }
    }

    // MARK: - 04 ToastHUD 可选值驱动
    private var toastHUDSection: some View {
        AuraSection("可选值驱动悬浮提示 (ToastHUD)", icon: "bell.badge.fill") {
            BaseCard {
                VStack(spacing: DesignSystem.Spacing.large) {
                    Text("原生毛玻璃胶囊预览")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Color.textSecondary)

                    ToastHUD("文稿已成功存入爆款智库", icon: "sparkles", iconColor: selectedTheme.color)

                    FormRowActionButton(
                        title: "触发可选值驱动 Toast (Binding)",
                        icon: "hand.tap.fill",
                        role: .regular
                    ) {
                        toastMessage = "动态提示：操作已由 Binding 驱动弹出"
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview("Upstream Backlog Showcase - Light") {
    UpstreamBacklogShowcaseView()
}

#Preview("Upstream Backlog Showcase - Dark") {
    UpstreamBacklogShowcaseView()
        .preferredColorScheme(.dark)
}
