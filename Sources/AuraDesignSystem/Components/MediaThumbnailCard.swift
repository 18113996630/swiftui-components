import SwiftUI

/// Aura 标杆风格通用媒体缩略图卡片（Media Thumbnail Card）
///
/// 专用于在横向滚动流（ScrollView 水平列表）、网格画板或文稿附件区域展示音视频录像、图文海报与多媒体素材。
/// 封装了 14pt 连续曲率超椭圆圆角、高对比度深色磨砂时长徽标（带 `.monospacedDigit()`）、
/// 居中半透明播放徽标与 0.97 物理按压缩放反馈（`ScaleButtonStyle`）。
///
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【时长微标防发虚与防抖动】：时长文本严格修饰 `.monospacedDigit()`，且强制使用黑色半透明（0.68）圆角胶囊底座承托白字，严禁在浅色封面上直接裸露浅灰字符；
/// 2. 【物理微缩触感】：卡片可点击交互强制绑定 `ScaleButtonStyle` 与 `HapticManager.impact(.light)` 触觉震动反馈；
/// 3. 【多语言副标题折行保护】：底部文本使用 `VStack(alignment: .leading)`，主标题单行截断，辅助时效严格使用 `DesignSystem.Color.textSecondary`（禁止二次叠加 opacity）；
/// 4. 【超椭圆圆角一致性】：封面与外框严格锁定 14pt 连续曲率超椭圆（.continuous），杜绝直角生硬切割感。
///
/// ```swift
/// // 1. 基础便捷调用（带时长与时间说明）
/// MediaThumbnailCard(
///     duration: "01:24",
///     title: "提词试录 01",
///     subtitle: "今天 14:20"
/// ) {
///     playVideo()
/// }
///
/// // 2. 自定义封面内容（支持 AsyncImage / 本地 Image）
/// MediaThumbnailCard(
///     duration: "02:45",
///     title: "小红书爆款图文",
///     subtitle: "已生成海报"
/// ) {
///     AsyncImage(url: coverURL) { image in
///         image.resizable().aspectRatio(contentMode: .fill)
///     } placeholder: {
///         Color.gray.opacity(0.15)
///     }
/// } action: {
///     openPreview()
/// }
/// ```
public struct MediaThumbnailCard<ThumbnailContent: View>: View {
    @Environment(\.themePalette) private var themePalette

    private let title: LocalizedText?
    private let subtitle: LocalizedText?
    private let duration: String?
    private let badgeText: LocalizedText?
    private let badgeColor: Color?
    private let showPlayButton: Bool
    private let width: CGFloat
    private let height: CGFloat
    private let action: () -> Void
    private let thumbnailContent: ThumbnailContent

    /// 完整自定义封面初始化器（本地化版本）
    public init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        duration: String? = nil,
        badge: LocalizedStringKey? = nil,
        badgeColor: Color? = nil,
        showPlayButton: Bool = true,
        width: CGFloat = 140,
        height: CGFloat = 88,
        @ViewBuilder thumbnail: () -> ThumbnailContent,
        action: @escaping () -> Void = {}
    ) {
        self.title = title.map { .localized($0) }
        self.subtitle = subtitle.map { .localized($0) }
        self.duration = duration
        self.badgeText = badge.map { .localized($0) }
        self.badgeColor = badgeColor
        self.showPlayButton = showPlayButton
        self.width = width
        self.height = height
        self.thumbnailContent = thumbnail()
        self.action = action
    }

    /// 完整自定义封面初始化器（动态非本地化直出）
    public init(
        verbatimTitle: String? = nil,
        verbatimSubtitle: String? = nil,
        duration: String? = nil,
        verbatimBadge: String? = nil,
        badgeColor: Color? = nil,
        showPlayButton: Bool = true,
        width: CGFloat = 140,
        height: CGFloat = 88,
        @ViewBuilder thumbnail: () -> ThumbnailContent,
        action: @escaping () -> Void = {}
    ) {
        self.title = verbatimTitle.map { .verbatim($0) }
        self.subtitle = verbatimSubtitle.map { .verbatim($0) }
        self.duration = duration
        self.badgeText = verbatimBadge.map { .verbatim($0) }
        self.badgeColor = badgeColor
        self.showPlayButton = showPlayButton
        self.width = width
        self.height = height
        self.thumbnailContent = thumbnail()
        self.action = action
    }

    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.tiny + 2) {
                // MARK: - 缩略图封面核心区
                ZStack(alignment: .bottomTrailing) {
                    thumbnailContent
                        .frame(width: width, height: height)
                        .clipped()
                        .background(DesignSystem.Color.fillTertiary)

                    // 居中半透明毛玻璃播放徽标
                    if showPlayButton {
                        Circle()
                            .fill(Color.black.opacity(0.38))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .offset(x: 1.5)
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }

                    // 左上角可选状态小微标
                    if let badgeText {
                        badgeText.makeText()
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(badgeColor ?? themePalette.color)
                            .clipShape(Capsule())
                            .padding(6)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }

                    // 右下角高对比度时长微标
                    if let duration, !duration.isEmpty {
                        Text(duration)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.68))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .padding(6)
                    }
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 0.5)
                )
                .shadow(
                    color: DesignSystem.Shadow.ambient.color,
                    radius: DesignSystem.Shadow.ambient.radius,
                    x: DesignSystem.Shadow.ambient.x,
                    y: DesignSystem.Shadow.ambient.y
                )

                // MARK: - 底部文本微排版
                if title != nil || subtitle != nil {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title {
                            title.makeText()
                                .font(DesignSystem.Typography.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Color.textPrimary)
                                .lineLimit(1)
                                .frame(maxWidth: width, alignment: .leading)
                        }

                        if let subtitle {
                            subtitle.makeText()
                                .font(.system(size: 11, weight: .regular, design: .rounded))
                                .foregroundColor(DesignSystem.Color.textSecondary)
                                .lineLimit(1)
                                .frame(maxWidth: width, alignment: .leading)
                        }
                    }
                    .frame(width: width, alignment: .leading)
                }
            }
        }
        .buttonStyle(.scale)
    }
}

// MARK: - 便捷扩展：默认使用占位渐变背景
extension MediaThumbnailCard where ThumbnailContent == DefaultMediaPlaceholderView {
    /// 便捷初始化器（使用默认视频占位背景，本地化版本）
    public init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        duration: String? = nil,
        badge: LocalizedStringKey? = nil,
        badgeColor: Color? = nil,
        showPlayButton: Bool = true,
        width: CGFloat = 140,
        height: CGFloat = 88,
        systemIcon: String = "video.fill",
        action: @escaping () -> Void = {}
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            duration: duration,
            badge: badge,
            badgeColor: badgeColor,
            showPlayButton: showPlayButton,
            width: width,
            height: height,
            thumbnail: {
                DefaultMediaPlaceholderView(systemIcon: systemIcon)
            },
            action: action
        )
    }

    /// 便捷初始化器（使用默认视频占位背景，动态非本地化直出）
    public init(
        verbatimTitle: String? = nil,
        verbatimSubtitle: String? = nil,
        duration: String? = nil,
        verbatimBadge: String? = nil,
        badgeColor: Color? = nil,
        showPlayButton: Bool = true,
        width: CGFloat = 140,
        height: CGFloat = 88,
        systemIcon: String = "video.fill",
        action: @escaping () -> Void = {}
    ) {
        self.init(
            verbatimTitle: verbatimTitle,
            verbatimSubtitle: verbatimSubtitle,
            duration: duration,
            verbatimBadge: verbatimBadge,
            badgeColor: badgeColor,
            showPlayButton: showPlayButton,
            width: width,
            height: height,
            thumbnail: {
                DefaultMediaPlaceholderView(systemIcon: systemIcon)
            },
            action: action
        )
    }
}

/// 默认媒体占位渐变视图
public struct DefaultMediaPlaceholderView: View {
    let systemIcon: String

    public init(systemIcon: String = "video.fill") {
        self.systemIcon = systemIcon
    }

    public var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.18, green: 0.22, blue: 0.28),
                Color(red: 0.12, green: 0.14, blue: 0.18)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            Image(systemName: systemIcon)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(.white.opacity(0.25))
        )
    }
}

#Preview("MediaThumbnailCard Variations") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        VStack(spacing: DesignSystem.Spacing.large) {
            Text("横向关联媒体流 (ScrollView)")
                .font(DesignSystem.Typography.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    MediaThumbnailCard(
                        verbatimTitle: "试录第一段 (完整)",
                        verbatimSubtitle: "今天 14:20 · 4K",
                        duration: "01:24",
                        verbatimBadge: "精选",
                        badgeColor: ThemePalette.coral.color
                    ) {
                        print("Tapped video 1")
                    }

                    MediaThumbnailCard(
                        verbatimTitle: "中景重录 (带停顿)",
                        verbatimSubtitle: "昨天 19:40 · 1080P",
                        duration: "00:48"
                    ) {
                        print("Tapped video 2")
                    }

                    // 自定义纯色封面卡片
                    MediaThumbnailCard(
                        verbatimTitle: "小红书长图海报",
                        verbatimSubtitle: "已生成 1 张",
                        duration: "长图",
                        showPlayButton: false
                    ) {
                        LinearGradient(
                            colors: [.purple.opacity(0.6), .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .overlay(
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(.white.opacity(0.85))
                        )
                    } action: {
                        print("Tapped poster")
                    }
                }
                .padding(.horizontal, DesignSystem.Layout.pagePadding)
            }
        }
        .padding(.vertical, DesignSystem.Layout.pagePadding)
        .themePalette(.indigo)
    }
}
