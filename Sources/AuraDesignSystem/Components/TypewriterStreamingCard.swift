import SwiftUI

/// 打字机流式生成与呼吸光标卡片（Aura 风格）
///
/// 专用于 AI 生成、智能改写或流式文稿输出，内置呼吸闪烁光标与优雅的停止生成控制。
/// 严格遵循状态以纯图标/动画表达优先的无硬编码原则，全面支持 Xcode 15+ String Catalog 自动抓取与 Verbatim 直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【状态优先纯图标】：生成中状态默认通过多巴胺呼吸律动脉冲呈现，无需强绑定语言文案，杜绝多语言截断；
/// 2. 【停止按键自适应】：若未传入 `stopActionTitle`，默认呈现紧凑型 `stop.fill` 纯图标胶囊按键，具备 0.97 按压缩放触觉反馈；
/// 3. 【零内置文案】：全域无任何硬编码业务字串，所有展示标题与操作文本均由外部注入。
///
/// ```swift
/// // 1. 本地化字面量（纯图标状态，Xcode 自动提取）
/// TypewriterStreamingCard(
///     "ai_generation_title",
///     streamingText: generatedText,
///     isGenerating: isThinking,
///     onStop: { isThinking = false }
/// )
///
/// // 2. 传入自定义状态与操作文案
/// TypewriterStreamingCard(
///     "ai_generation_title",
///     streamingText: generatedText,
///     isGenerating: isThinking,
///     statusTitle: "status_generating",
///     stopActionTitle: "action_stop",
///     onStop: { isThinking = false }
/// )
/// ```
public struct TypewriterStreamingCard: View {
    @Environment(\.themePalette) private var themePalette

    private let title: LocalizedText
    private let streamingText: String
    private let isGenerating: Bool
    private let statusTitle: LocalizedText?
    private let stopActionTitle: LocalizedText?
    private let onStop: (() -> Void)?

    @State private var cursorVisible = true

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        streamingText: String,
        isGenerating: Bool,
        statusTitle: LocalizedStringKey? = nil,
        stopActionTitle: LocalizedStringKey? = nil,
        onStop: (() -> Void)? = nil
    ) {
        self.title = .localized(title)
        self.streamingText = streamingText
        self.isGenerating = isGenerating
        self.statusTitle = statusTitle.map { .localized($0) }
        self.stopActionTitle = stopActionTitle.map { .localized($0) }
        self.onStop = onStop
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        streamingText: String,
        isGenerating: Bool,
        statusTitle: LocalizedStringKey? = nil,
        stopActionTitle: LocalizedStringKey? = nil,
        onStop: (() -> Void)? = nil
    ) {
        self.init(
            title,
            streamingText: streamingText,
            isGenerating: isGenerating,
            statusTitle: statusTitle,
            stopActionTitle: stopActionTitle,
            onStop: onStop
        )
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        streamingText: String,
        isGenerating: Bool,
        statusTitle: String? = nil,
        stopActionTitle: String? = nil,
        onStop: (() -> Void)? = nil
    ) {
        self.title = .verbatim(title)
        self.streamingText = streamingText
        self.isGenerating = isGenerating
        self.statusTitle = statusTitle.map { .verbatim($0) }
        self.stopActionTitle = stopActionTitle.map { .verbatim($0) }
        self.onStop = onStop
    }

    public var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                // 顶栏状态与标题
                HStack {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(themePalette.color)

                        title.makeText()
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Color.textPrimary)
                    }

                    Spacer()

                    if isGenerating {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(themePalette.color)
                                .frame(width: 6, height: 6)
                                .scaleEffect(cursorVisible ? 1.0 : 0.6)
                                .opacity(cursorVisible ? 1.0 : 0.4)

                            if let statusTitle {
                                statusTitle.makeText()
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(themePalette.color)
                            }
                        }
                    }
                }

                Divider()

                // 流式文本内容与闪烁光标
                HStack(alignment: .bottom, spacing: 2) {
                    Text(streamingText)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textPrimary)
                        .lineSpacing(4)

                    if isGenerating {
                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                            .fill(themePalette.color)
                            .frame(width: 2.5, height: 16)
                            .opacity(cursorVisible ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: cursorVisible)
                            .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, DesignSystem.Spacing.tiny)

                // 底部停止生成按键
                if isGenerating, let onStop {
                    HStack {
                        Spacer()
                        Button(action: {
                            HapticManager.impact(.light)
                            onStop()
                        }) {
                            HStack(spacing: DesignSystem.Spacing.tiny) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 11, weight: .bold))

                                if let stopActionTitle {
                                    stopActionTitle.makeText()
                                        .font(DesignSystem.Typography.caption)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.horizontal, stopActionTitle != nil ? DesignSystem.Spacing.large : 12)
                            .padding(.vertical, DesignSystem.Spacing.small)
                            .background(ThemePalette.coral.tint)
                            .foregroundColor(ThemePalette.coral.color)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.top, DesignSystem.Spacing.tiny)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            if isGenerating {
                cursorVisible.toggle()
            }
        }
    }
}

#Preview("TypewriterStreamingCard Preview") {
    TypewriterStreamingPreviewHelper()
}

private struct TypewriterStreamingPreviewHelper: View {
    @State private var isGenerating = true
    @State private var text = "正在为您提炼爆款文案框架：\n1. 黄金前三秒黄金抓手：直接切入痛点。\n2. 认知反差反转：给出意料之外的解决方案。\n3. 情绪价值放大：引导完播与深度点赞。"

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                TypewriterStreamingCard(
                    "AI 爆款框架推导",
                    streamingText: text,
                    isGenerating: isGenerating
                ) {
                    isGenerating = false
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
            .themePalette(.teal)
        }
    }
}
