import SwiftUI

/// Structured 风格 9 大多巴胺活力主题色板
public enum ThemePalette: String, CaseIterable, Identifiable, Sendable {
    case coral = "coral"       // 珊瑚粉红
    case orange = "orange"     // 暖日阳光
    case amber = "amber"       // 琥珀金黄
    case sage = "sage"         // 抹茶淡绿
    case indigo = "indigo"     // 晴空靛蓝
    case teal = "teal"         // 翡翠青绿
    case berry = "berry"       // 标志浆果红 (Default)
    case navy = "navy"         // 午夜藏蓝
    case charcoal = "charcoal" // 极简炭黑

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .coral: return "珊瑚粉"
        case .orange: return "暖日橙"
        case .amber: return "琥珀黄"
        case .sage: return "抹茶绿"
        case .indigo: return "晴空蓝"
        case .teal: return "翡翠青"
        case .berry: return "浆果红"
        case .navy: return "午夜蓝"
        case .charcoal: return "极简黑"
        }
    }

    public var color: SwiftUI.Color {
        switch self {
        case .coral: return SwiftUI.Color(red: 0.95, green: 0.52, blue: 0.52)
        case .orange: return SwiftUI.Color(red: 0.96, green: 0.58, blue: 0.39)
        case .amber: return SwiftUI.Color(red: 0.90, green: 0.66, blue: 0.24)
        case .sage: return SwiftUI.Color(red: 0.56, green: 0.75, blue: 0.42)
        case .indigo: return SwiftUI.Color(red: 0.36, green: 0.51, blue: 0.73)
        case .teal: return SwiftUI.Color(red: 0.17, green: 0.51, blue: 0.44)
        case .berry: return SwiftUI.Color(red: 0.52, green: 0.20, blue: 0.32)
        case .navy: return SwiftUI.Color(red: 0.18, green: 0.25, blue: 0.34)
        case .charcoal: return SwiftUI.Color(red: 0.13, green: 0.13, blue: 0.13)
        }
    }

    public var tint: SwiftUI.Color {
        color.opacity(0.15)
    }

    public var gradient: LinearGradient {
        switch self {
        case .coral:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.98, green: 0.65, blue: 0.65), SwiftUI.Color(red: 0.92, green: 0.45, blue: 0.45)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .orange:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.98, green: 0.70, blue: 0.52), SwiftUI.Color(red: 0.94, green: 0.50, blue: 0.32)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .amber:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.96, green: 0.78, blue: 0.42), SwiftUI.Color(red: 0.86, green: 0.58, blue: 0.18)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .sage:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.68, green: 0.84, blue: 0.56), SwiftUI.Color(red: 0.48, green: 0.68, blue: 0.34)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .indigo:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.48, green: 0.62, blue: 0.82), SwiftUI.Color(red: 0.28, green: 0.42, blue: 0.65)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .teal:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.28, green: 0.62, blue: 0.54), SwiftUI.Color(red: 0.12, green: 0.44, blue: 0.38)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .berry:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.68, green: 0.30, blue: 0.44), SwiftUI.Color(red: 0.46, green: 0.14, blue: 0.26)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .navy:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.28, green: 0.36, blue: 0.48), SwiftUI.Color(red: 0.12, green: 0.18, blue: 0.26)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .charcoal:
            return LinearGradient(
                colors: [SwiftUI.Color(red: 0.25, green: 0.25, blue: 0.25), SwiftUI.Color(red: 0.08, green: 0.08, blue: 0.08)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
}

/// 全局设计系统命名空间
public enum DesignSystem {
    public enum Color {
        public static let defaultPalette = ThemePalette.berry
        public static let primary = defaultPalette.color
        public static let primaryLight = defaultPalette.tint
        public static let proGradient = defaultPalette.gradient

        public static let background = SwiftUI.Color(uiColor: .systemGroupedBackground)
        public static let cardBackground = SwiftUI.Color(uiColor: .secondarySystemGroupedBackground)
        public static let textPrimary = SwiftUI.Color.primary
        public static let textSecondary = SwiftUI.Color.secondary.opacity(0.8)
        public static let textTertiary = SwiftUI.Color(uiColor: .tertiaryLabel)
    }

    public enum Typography {
        public static let largeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
        public static let title = Font.system(size: 20, weight: .bold, design: .rounded)
        public static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        public static let body = Font.system(size: 15, weight: .regular, design: .rounded)
        public static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
        public static let time = Font.system(size: 13, weight: .medium, design: .rounded)
    }

    public enum Spacing {
        public static let tiny: CGFloat = 4
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let xLarge: CGFloat = 24
        public static let xxLarge: CGFloat = 32
    }

    public enum CornerRadius {
        public static let small: CGFloat = 8
        public static let button: CGFloat = 14
        public static let card: CGFloat = 20
        public static let largeCard: CGFloat = 28 // Structured 悬浮画板大圆角
        public static let capsule: CGFloat = 999
    }

    public enum Shadow {
        public static let ambient = ShadowStyle(
            color: SwiftUI.Color.black.opacity(0.04),
            radius: 24,
            x: 0,
            y: 8
        )
        public static let floating = ShadowStyle(
            color: SwiftUI.Color.black.opacity(0.07),
            radius: 32,
            x: 0,
            y: 12
        )
        public static let light = ambient
        public static let medium = floating
    }

    public enum Iconography {
        public static let sizeSmall: CGFloat = 16
        public static let sizeMedium: CGFloat = 24
        public static let sizeLarge: CGFloat = 38 // 饱满时间线节点尺寸
        public static let symbolWeight: Font.Weight = .semibold
    }

    public enum Layout {
        public static let pagePadding: CGFloat = 16
        public static let cardPadding: CGFloat = 20
        public static let sectionSpacing: CGFloat = 24
        public static let rowHeight: CGFloat = 44
        public static let iconTextSpacing: CGFloat = 14
    }

    public enum Motion {
        public static let pressScale: CGFloat = 0.97
        public static let pressOpacity: CGFloat = 0.82
        public static let standardAnimation = Animation.easeInOut(duration: 0.15)
        public static let springAnimation = Animation.spring(
            response: 0.3,
            dampingFraction: 0.72
        )
    }
}

public struct ShadowStyle: Sendable {
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
