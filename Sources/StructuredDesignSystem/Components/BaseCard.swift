import SwiftUI

/// Structured 标杆风格浮岛卡片容器（内容保护仓）
///
/// 统一封装 28pt 连续曲率超椭圆、纯白卡片底座（#FFFFFF）与 24pt 漫反射软阴影。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【文字入仓】：两行以上的正文说明、表单列表与交互控件必须置于 `BaseCard` 内，严禁裸露在冷灰底板上；
/// 2. 【对比度标准】：卡片内正文使用 `DesignSystem.Typography.body`，副标题使用 `DesignSystem.Color.textSecondary`，严禁在此基础上叠加 `.opacity(...)`；
/// 3. 【内边距约束】：默认注入 20pt 呼吸内边距，除特定边缘嵌合组件（如 HeroBanner）外严禁随意覆盖为 0。
///
/// ```swift
/// BaseCard {
///     VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
///         Text("卡片主标题").font(DesignSystem.Typography.headline)
///         Text("正文说明文案").font(DesignSystem.Typography.body).foregroundColor(DesignSystem.Color.textSecondary)
///     }
/// }
/// ```
public struct BaseCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let showBorder: Bool
    private let backgroundColor: Color
    private let content: Content

    public init(
        cornerRadius: CGFloat = DesignSystem.CornerRadius.largeCard,
        padding: CGFloat = DesignSystem.Layout.cardPadding,
        showBorder: Bool = false,
        backgroundColor: Color = DesignSystem.Color.cardBackground,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        showBorder ? Color.primary.opacity(0.06) : Color.clear,
                        lineWidth: 0.5
                    )
            )
            .shadow(
                color: DesignSystem.Shadow.ambient.color,
                radius: DesignSystem.Shadow.ambient.radius,
                x: DesignSystem.Shadow.ambient.x,
                y: DesignSystem.Shadow.ambient.y
            )
    }
}

#Preview("BaseCard - Light") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        VStack(spacing: DesignSystem.Spacing.large) {
            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("基础卡片容器 (28pt)")
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Color.textPrimary)

                    Text("统一了 28pt 浮岛圆角、二级分组背景色与柔和弥散阴影，为内容提供呼吸感。")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 16, showBorder: true) {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    Circle()
                        .fill(DesignSystem.Color.primary.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "sparkles")
                                .foregroundColor(DesignSystem.Color.primary)
                        )

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.tiny) {
                        Text("20pt 带边框次级卡片")
                            .font(DesignSystem.Typography.headline)
                        Text("支持自由调节圆角与内边距")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
            }
        }
        .padding(DesignSystem.Layout.pagePadding)
    }
}

#Preview("BaseCard - Dark") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        BaseCard {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("深色模式卡片")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Text("自动切换至深色次级分组背景，保持层级对比。")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Color.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DesignSystem.Layout.pagePadding)
    }
    .preferredColorScheme(.dark)
}
