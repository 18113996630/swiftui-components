import SwiftUI

/// 时间线任务节点行
public struct TimelineTaskRow: View {
    private let time: String
    private let title: String
    private let subtitle: String?
    private let icon: String
    private let color: Color
    private let isLast: Bool

    public init(
        time: String,
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: Color,
        isLast: Bool
    ) {
        self.time = time
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.isLast = isLast
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
            VStack(spacing: 0) {
                Text(time)
                    .font(DesignSystem.Typography.time)
                    .foregroundColor(DesignSystem.Color.textTertiary)
                    .frame(width: 40, alignment: .trailing)

                Spacer().frame(height: DesignSystem.Spacing.tiny)

                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 24, height: 24)

                    Image(systemName: icon)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(color)
                }

                if !isLast {
                    Rectangle()
                        .fill(SwiftUI.Color.gray.opacity(0.2))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.tiny) {
                Text(title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }

                HStack(spacing: DesignSystem.Spacing.small) {
                    PillButton(title: "0/5", icon: "checklist", action: {})

                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
                .padding(.top, DesignSystem.Spacing.tiny)
            }
            .padding(.bottom, DesignSystem.Spacing.xLarge)

            Spacer()

            Circle()
                .strokeBorder(DesignSystem.Color.primary.opacity(0.5), lineWidth: 1.5)
                .frame(width: 20, height: 20)
        }
    }
}
