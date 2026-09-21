import SwiftUI

/// 胶囊状标签按钮
public struct PillButton: View {
    private let title: String
    private let icon: String?
    private let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
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
            .background(DesignSystem.Color.primaryLight)
            .foregroundColor(DesignSystem.Color.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
