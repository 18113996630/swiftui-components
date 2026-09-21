import SwiftUI

/// 基础卡片容器，统一圆角、背景色和阴影
public struct BaseCard<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(DesignSystem.Layout.cardPadding)
            .background(DesignSystem.Color.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.card)
            .shadow(
                color: DesignSystem.Shadow.light.color,
                radius: DesignSystem.Shadow.light.radius,
                x: DesignSystem.Shadow.light.x,
                y: DesignSystem.Shadow.light.y
            )
    }
}
