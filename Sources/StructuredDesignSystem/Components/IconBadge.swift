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
            .font(.system(size: size * 0.5, weight: DesignSystem.Iconography.symbolWeight))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(color)
            .cornerRadius(size * 0.3)
    }
}
