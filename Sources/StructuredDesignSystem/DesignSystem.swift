import SwiftUI

/// 全局设计系统命名空间
public enum DesignSystem {
    public enum Color {
        public static let primary = SwiftUI.Color(red: 0.65, green: 0.30, blue: 0.45)
        public static let primaryLight = SwiftUI.Color(red: 0.95, green: 0.85, blue: 0.88)
        public static let background = SwiftUI.Color(uiColor: .systemGroupedBackground)
        public static let cardBackground = SwiftUI.Color(uiColor: .secondarySystemGroupedBackground)
        public static let textPrimary = SwiftUI.Color.primary
        public static let textSecondary = SwiftUI.Color.secondary.opacity(0.8)
        public static let textTertiary = SwiftUI.Color(uiColor: .tertiaryLabel)

        public static let proGradient = LinearGradient(
            colors: [
                SwiftUI.Color(red: 0.95, green: 0.70, blue: 0.70),
                SwiftUI.Color(red: 0.85, green: 0.50, blue: 0.60)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public enum Typography {
        public static let title = Font.system(size: 20, weight: .bold, design: .rounded)
        public static let headline = Font.system(size: 17, weight: .semibold)
        public static let body = Font.system(size: 15, weight: .regular)
        public static let caption = Font.system(size: 13, weight: .regular)
        public static let time = Font.system(size: 12, weight: .medium, design: .monospaced)
    }

    public enum Spacing {
        public static let tiny: CGFloat = 4
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let xLarge: CGFloat = 24
    }

    public enum CornerRadius {
        public static let small: CGFloat = 8
        public static let button: CGFloat = 12
        public static let card: CGFloat = 16
        public static let capsule: CGFloat = 999
    }

    public enum Shadow {
        public static let light = ShadowStyle(
            color: SwiftUI.Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 4
        )
        public static let medium = ShadowStyle(
            color: SwiftUI.Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
    }

    public enum Iconography {
        public static let sizeSmall: CGFloat = 16
        public static let sizeMedium: CGFloat = 24
        public static let sizeLarge: CGFloat = 32
        public static let symbolWeight: Font.Weight = .semibold
    }

    public enum Layout {
        public static let pagePadding: CGFloat = 16
        public static let cardPadding: CGFloat = 16
        public static let sectionSpacing: CGFloat = 24
        public static let rowHeight: CGFloat = 44
        public static let iconTextSpacing: CGFloat = 12
    }

    public enum Motion {
        public static let pressScale: CGFloat = 0.97
        public static let pressOpacity: CGFloat = 0.8
        public static let standardAnimation = Animation.easeInOut(duration: 0.15)
        public static let springAnimation = Animation.spring(
            response: 0.3,
            dampingFraction: 0.7
        )
    }
}

public struct ShadowStyle {
    public let color: SwiftUI.Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(
        color: SwiftUI.Color,
        radius: CGFloat,
        x: CGFloat,
        y: CGFloat
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
