import SwiftUI

/// 标杆级居中空状态视图（Structured 风格）
/// 严格贴合规范：大图标柔和底座 + SF Pro Rounded 标题 + 辅助说明文案 + 可选操作动作插槽
public struct EmptyStateView<ActionContent: View>: View {
    @Environment(\.themePalette) private var themePalette

    private let icon: String
    private let title: String
    private let description: String?
    private let iconColor: Color?
    private let action: ActionContent

    public init(
        icon: String,
        title: String,
        description: String? = nil,
        iconColor: Color? = nil,
        @ViewBuilder action: () -> ActionContent
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.iconColor = iconColor
        self.action = action()
    }

    private var effectiveColor: Color {
        iconColor ?? themePalette.color
    }

    public var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // 大图标柔和底座
            ZStack {
                Circle()
                    .fill(effectiveColor.opacity(0.12))
                    .frame(width: 72, height: 72)

                Image(systemName: icon)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(effectiveColor)
            }

            VStack(spacing: DesignSystem.Spacing.tiny) {
                Text(title)
                    .font(DesignSystem.Typography.title)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                if let description {
                    Text(description)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                }
            }

            action
        }
        .padding(DesignSystem.Layout.cardPadding)
        .frame(maxWidth: .infinity)
    }
}

public extension EmptyStateView where ActionContent == EmptyView {
    init(
        icon: String,
        title: String,
        description: String? = nil,
        iconColor: Color? = nil
    ) {
        self.init(
            icon: icon,
            title: title,
            description: description,
            iconColor: iconColor
        ) {
            EmptyView()
        }
    }
}

#Preview("EmptyStateView Preview") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        VStack {
            BaseCard {
                EmptyStateView(
                    icon: "doc.text.magnifyingglass",
                    title: "暂无提词文稿",
                    description: "点击下方按钮开始创作你的第一篇口播文案，或直接导入链接。"
                ) {
                    PillButton(title: "新建提词脚本", icon: "plus", action: {})
                }
            }
        }
        .padding(DesignSystem.Layout.pagePadding)
        .themePalette(.teal)
    }
}
