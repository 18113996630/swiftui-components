import SwiftUI

/// 标杆级沉浸式彩色顶栏卡片/弹窗容器（Aura 风格）
///
/// 对应任务编辑与新建任务时的彩色渐变顶栏、超椭圆白色图标、关闭胶囊与步骤指示器。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：顶栏标题、副标题与步骤微标纯由外部注入；
/// 2. 【28pt 浮岛圆角】：外层容器强制裁剪为 `largeCard` (28pt) 连续曲率超椭圆；
/// 3. 【多巴胺顶栏】：顶栏采用对应 `ThemePalette.gradient`，图标置于 52x52 纯白超椭圆底座中。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// HeroBannerSheet(
///     "sheet_edit_task_title",
///     subtitle: "sheet_edit_task_time",
///     stepText: "step_suggestion",
///     icon: "envelope.fill",
///     palette: .berry
/// ) {
///     contentView
/// }
///
/// // 2. 动态非本地化直出
/// HeroBannerSheet(
///     verbatim: event.title,
///     subtitle: event.timeDescription,
///     icon: event.icon
/// ) {
///     contentView
/// }
/// ```
public struct HeroBannerSheet<Content: View>: View {
    private let title: LocalizedText
    private let subtitle: LocalizedText?
    private let stepText: LocalizedText?
    private let icon: String
    private let palette: ThemePalette
    private let onClose: (() -> Void)?
    private let onTrailingAction: (() -> Void)?
    private let content: Content

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        stepText: LocalizedStringKey? = nil,
        icon: String = "sparkles",
        palette: ThemePalette = .berry,
        onClose: (() -> Void)? = nil,
        onTrailingAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = .localized(title)
        self.subtitle = subtitle.map { .localized($0) }
        self.stepText = stepText.map { .localized($0) }
        self.icon = icon
        self.palette = palette
        self.onClose = onClose
        self.onTrailingAction = onTrailingAction
        self.content = content()
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        stepText: LocalizedStringKey? = nil,
        icon: String = "sparkles",
        palette: ThemePalette = .berry,
        onClose: (() -> Void)? = nil,
        onTrailingAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title,
            subtitle: subtitle,
            stepText: stepText,
            icon: icon,
            palette: palette,
            onClose: onClose,
            onTrailingAction: onTrailingAction,
            content: content
        )
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        subtitle: String? = nil,
        stepText: String? = nil,
        icon: String = "sparkles",
        palette: ThemePalette = .berry,
        onClose: (() -> Void)? = nil,
        onTrailingAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = .verbatim(title)
        self.subtitle = subtitle.map { .verbatim($0) }
        self.stepText = stepText.map { .verbatim($0) }
        self.icon = icon
        self.palette = palette
        self.onClose = onClose
        self.onTrailingAction = onTrailingAction
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - 沉浸式 Hero Banner 头部
            ZStack(alignment: .top) {
                // 背景渐变
                palette.gradient
                    .frame(height: 170)

                VStack(alignment: .leading, spacing: 0) {
                    // 顶栏操作区 (关闭与更多)
                    HStack {
                        if let onClose {
                            Button(action: onClose) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.white.opacity(0.22))
                                    .clipShape(Circle())
                                    .frame(minWidth: 44, minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.scale)
                        }

                        Spacer()

                        if let onTrailingAction {
                            Button(action: onTrailingAction) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.white.opacity(0.22))
                                    .clipShape(Circle())
                                    .frame(minWidth: 44, minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.scale)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Layout.cardPadding)
                    .padding(.top, DesignSystem.Spacing.medium)

                    Spacer()

                    // 主题图标与标题区
                    HStack(spacing: DesignSystem.Spacing.medium) {
                        // 白色超椭圆图标徽章
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.white)
                                .frame(width: 52, height: 52)
                                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                            Image(systemName: icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(palette.color)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            if let stepText {
                                stepText.makeText()
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(Color.white.opacity(0.8))
                            }

                            title.makeText()
                                .font(DesignSystem.Typography.title)
                                .foregroundColor(.white)

                            if let subtitle {
                                subtitle.makeText()
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(Color.white.opacity(0.85))
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, DesignSystem.Layout.cardPadding)
                    .padding(.bottom, DesignSystem.Spacing.large)
                }
            }

            // MARK: - 下方内容区
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DesignSystem.Color.background)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.largeCard, style: .continuous))
    }
}

#Preview("HeroBannerSheet Preview") {
    ZStack {
        Color.black.opacity(0.2).ignoresSafeArea()

        HeroBannerSheet(
            "回复邮件与方案",
            subtitle: "10:00 - 10:45 • 45分钟",
            stepText: "建议任务",
            icon: "envelope.fill",
            palette: .berry,
            onClose: {},
            onTrailingAction: {}
        ) {
            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("任务配置")
                            .font(DesignSystem.Typography.headline)
                        Text("可在下方自由嵌入日程表单、清单项或参数选择器。")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
        .frame(height: 520)
        .padding()
    }
}
