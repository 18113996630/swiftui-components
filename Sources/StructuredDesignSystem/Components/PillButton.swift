import SwiftUI

/// 胶囊状标签按钮（支持 @Environment(\.themePalette) 动态换肤）
public struct PillButton: View {
    @Environment(\.themePalette) private var themePalette
    private let title: String
    private let icon: String?
    private let customColor: Color?
    private let customBackground: Color?
    private let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        color: Color? = nil,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.customColor = color
        self.customBackground = backgroundColor
        self.action = action
    }

    private var activeColor: Color {
        customColor ?? themePalette.color
    }

    private var activeBackground: Color {
        customBackground ?? themePalette.tint
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.tiny) {
                if let icon {
                    Image(systemName: icon)
                }

                Text(title)
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.small)
            .background(activeBackground)
            .foregroundColor(activeColor)
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview("PillButton States") {
    VStack(spacing: DesignSystem.Spacing.large) {
        HStack(spacing: DesignSystem.Spacing.small) {
            PillButton(title: "带图标标签", icon: "sparkles", action: {})
            PillButton(title: "纯文本", action: {})
            PillButton(title: "3/8", icon: "checklist", action: {})
        }

        HStack(spacing: DesignSystem.Spacing.small) {
            PillButton(title: "自定义珊瑚色", icon: "heart.fill", color: ThemePalette.coral.color, backgroundColor: ThemePalette.coral.tint, action: {})
            PillButton(title: "快速同步", icon: "arrow.triangle.2.circlepath", action: {})
        }
    }
    .padding(DesignSystem.Layout.pagePadding)
    .themePalette(.indigo)
}
