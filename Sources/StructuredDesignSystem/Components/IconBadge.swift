import SwiftUI

/// 带有彩色背景的图标徽章
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
