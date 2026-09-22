import SwiftUI

/// 带有彩色背景的图标徽章底座
///
/// 专用于在设置行、卡片标头或功能列表中展示带有圆角背景的原生 SF Symbol 图标，
/// 统一采用 SF Pro Rounded 字体特征与连续超椭圆圆角（.continuous）。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 图标前景强制采用纯白色（`.white`），依靠背景彩色块区分层级，确保高对比度；
/// 2. 背景色必须配合设计令牌或 `ThemePalette` 使用，切勿随意使用低对比度浅灰色；
/// 3. 圆角率严格锁定为 `size * 0.28` 连续超椭圆（.continuous），保持与 iOS 系统设置一致的视觉亲和力。
///
/// ```swift
/// IconBadge(systemName: "star.fill", color: DesignSystem.Color.primary, size: 32)
/// IconBadge(systemName: "bell.fill", color: .orange)
/// ```
public struct IconBadge: View {
    private let systemName: String
    private let color: Color
    private let size: CGFloat

    public init(
        systemName: String,
        color: Color,
        size: CGFloat = DesignSystem.Iconography.sizeMedium
    ) {
        self.systemName = systemName
        self.color = color
        self.size = size
    }

    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.5, weight: DesignSystem.Iconography.symbolWeight, design: .rounded))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
    }
}

#Preview("IconBadge Variations") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HStack(spacing: DesignSystem.Spacing.medium) {
            IconBadge(
                systemName: "star.fill",
                color: DesignSystem.Color.primary,
                size: DesignSystem.Iconography.sizeSmall
            )

            IconBadge(
                systemName: "bell.fill",
                color: .orange,
                size: DesignSystem.Iconography.sizeMedium
            )

            IconBadge(
                systemName: "heart.fill",
                color: .red,
                size: DesignSystem.Iconography.sizeLarge
            )

            IconBadge(
                systemName: "bolt.fill",
                color: .blue,
                size: 44
            )
        }

        HStack(spacing: DesignSystem.Spacing.medium) {
            IconBadge(systemName: "gearshape.fill", color: .gray)
            IconBadge(systemName: "checkmark", color: .green)
            IconBadge(systemName: "flame.fill", color: .orange)
            IconBadge(systemName: "shield.fill", color: .purple)
            IconBadge(systemName: "sparkles", color: DesignSystem.Color.primary)
        }
    }
    .padding(DesignSystem.Layout.pagePadding)
}
