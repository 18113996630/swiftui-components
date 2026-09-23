import SwiftUI

/// Aura 标杆风格快捷入口卡片（Quick Action Card）
///
/// 专用于仪表盘、主页快捷通道、工具箱入口等双列或多列网格布局，
/// 包含左侧彩色超椭圆图标底座、SF Pro Rounded 粗体主标题、多语言弹性辅助副标题与轻量点击反馈。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【双列紧凑空间契合 (Spatial Harmony)】：主标题对齐 HIG Callout（15pt Semibold），副标题采用 HIG Caption（12pt Medium），释放 20%+ 负空间呼吸感，杜绝 17pt 大标挤爆并排卡片；
/// 2. 【国际化多语言自适应 (i18n Elasticity)】：考虑到德语、俄语、英语等长字符语言，副标题支持自适应弹性折行（最多 2 行），配备 `minimumScaleFactor(0.82)`，且卡片强制 `maxHeight: .infinity` 实现等高对齐，杜绝左右卡片高低不平与截断丢意；
/// 3. 【顶部顶格对齐 (Top-Pinned Anchor)】：容器采用 `HStack(alignment: .top)`，确保多语言长文案在多行排版时，左侧图标始终稳健锚定在顶部，杜绝居中飘移；
/// 4. 【高对比度与防发虚】：主标题使用 `DesignSystem.Color.textPrimary`，副标题使用 `DesignSystem.Color.textSecondary`，严禁二次叠加 opacity；
/// 5. 【触控人机工程】：默认内置 `ScaleButtonStyle` 物理弹性微缩（0.97）与 `HapticManager.impact(.light)` 触觉反馈，触控热区保证 >= 44x44pt。
///
/// ```swift
/// QuickActionCard(
///     icon: "lightbulb.fill",
///     iconColor: .indigo,
///     title: "灵感写稿",
///     subtitle: "AI 智能生成"
/// ) {
///     print("Tapped")
/// }
/// ```
public struct QuickActionCard: View {
    @Environment(\.themePalette) private var themePalette

    private let icon: String
    private let iconColor: Color?
    private let title: LocalizedText
    private let subtitle: LocalizedText?
    private let action: () -> Void

    /// 本地化初始化器（Apple 原生风格，支持 Xcode 自动抓取）
    public init(
        icon: String,
        iconColor: Color? = nil,
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = .localized(title)
        self.subtitle = subtitle.map { .localized($0) }
        self.action = action
    }

    /// 具名本地化初始化器
    public init(
        icon: String,
        iconColor: Color? = nil,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.init(icon: icon, iconColor: iconColor, title, subtitle: subtitle, action: action)
    }

    /// 混合直出初始化器：本地化标题 + 动态非本地化副标题
    public init(
        icon: String,
        iconColor: Color? = nil,
        _ title: LocalizedStringKey,
        verbatimSubtitle: String?,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = .localized(title)
        self.subtitle = verbatimSubtitle.map { .verbatim($0) }
        self.action = action
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = .verbatim(title)
        self.subtitle = subtitle.map { .verbatim($0) }
        self.action = action
    }

    private var effectiveIconColor: Color {
        iconColor ?? themePalette.color
    }

    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(alignment: .top, spacing: 10) {
                // 左侧锚定图标底座 (38pt 标准尺寸)
                IconBadge(
                    systemName: icon,
                    color: effectiveIconColor,
                    size: 38
                )

                // 右侧文本流 (支持多语言弹性伸缩与自动等高)
                VStack(alignment: .leading, spacing: 3) {
                    title.makeText()
                        .font(DesignSystem.Typography.callout)
                        .foregroundColor(DesignSystem.Color.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    if let subtitle {
                        subtitle.makeText()
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                            .lineLimit(2)
                            .lineSpacing(1.5)
                            .minimumScaleFactor(0.82)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(DesignSystem.Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
            )
            .shadow(
                color: DesignSystem.Shadow.ambient.color,
                radius: DesignSystem.Shadow.ambient.radius,
                x: DesignSystem.Shadow.ambient.x,
                y: DesignSystem.Shadow.ambient.y
            )
        }
        .buttonStyle(.scale)
    }
}

#Preview("QuickActionCard - Grid") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        VStack(spacing: 16) {
            // 中文测试
            HStack(spacing: DesignSystem.Spacing.medium) {
                QuickActionCard(
                    icon: "lightbulb.fill",
                    iconColor: .indigo,
                    title: "灵感写稿",
                    subtitle: "AI 智能生成"
                )

                QuickActionCard(
                    icon: "photo.badge.plus.fill",
                    iconColor: .orange,
                    title: "相册选图",
                    subtitle: "提取截屏文案"
                )
            }
            .fixedSize(horizontal: false, vertical: true)

            // 英文 / 国际化长文案测试 (验证 i18n 自适应与等高)
            HStack(spacing: DesignSystem.Spacing.medium) {
                QuickActionCard(
                    verbatim: "AI Scripting",
                    subtitle: "Generate from ideas",
                    icon: "lightbulb.fill",
                    iconColor: .indigo
                )

                QuickActionCard(
                    verbatim: "From Photos",
                    subtitle: "Extract text from screenshots",
                    icon: "photo.badge.plus.fill",
                    iconColor: .orange
                )
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignSystem.Layout.pagePadding)
    }
}
