import SwiftUI

/// 打字机流式生成与呼吸光标卡片（Structured 风格）
/// 专用于 AI 生成、智能改写或流式文稿输出，内置呼吸闪烁光标与优雅的停止生成控制
public struct TypewriterStreamingCard: View {
    @Environment(\.themePalette) private var themePalette

    private let title: String
    private let streamingText: String
    private let isGenerating: Bool
    private let onStop: (() -> Void)?

    @State private var cursorVisible = true

    public init(
        title: String,
        streamingText: String,
        isGenerating: Bool,
        onStop: (() -> Void)? = nil
    ) {
        self.title = title
        self.streamingText = streamingText
        self.isGenerating = isGenerating
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

                        Text(title)
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

                            Text("生成中...")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(themePalette.color)
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
                        PillButton(
                            title: "停止生成",
                            icon: "stop.fill",
                            color: ThemePalette.coral.color,
                            backgroundColor: ThemePalette.coral.tint
                        ) {
                            HapticManager.impact(.light)
                            onStop()
                        }
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
                    title: "AI 爆款框架推导",
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
