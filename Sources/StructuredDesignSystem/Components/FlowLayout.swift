import SwiftUI

/// 原生流式折行布局协议（Structured 规范实现）
/// 支持子视图自适应折行、灵活设置行间距/列间距与垂直对齐
public struct FlowLayout: Layout {
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    public var alignment: VerticalAlignment

    public init(
        horizontalSpacing: CGFloat = DesignSystem.Spacing.small,
        verticalSpacing: CGFloat = DesignSystem.Spacing.small,
        alignment: VerticalAlignment = .center
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                totalWidth = max(totalWidth, currentX - horizontalSpacing)
                currentX = 0
                currentY += lineHeight + verticalSpacing
                lineHeight = 0
            }

            currentX += size.width + horizontalSpacing
            lineHeight = max(lineHeight, size.height)
        }

        totalWidth = max(totalWidth, currentX > 0 ? currentX - horizontalSpacing : 0)
        let totalHeight = currentY + lineHeight
        return CGSize(width: totalWidth, height: totalHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var lineSubviews: [(subview: LayoutSubview, size: CGSize, x: CGFloat)] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0

        func flushLine() {
            for item in lineSubviews {
                let yOffset: CGFloat
                switch alignment {
                case .top:
                    yOffset = 0
                case .bottom:
                    yOffset = lineHeight - item.size.height
                default:
                    yOffset = (lineHeight - item.size.height) / 2
                }
                item.subview.place(
                    at: CGPoint(x: bounds.minX + item.x, y: currentY + yOffset),
                    proposal: ProposedViewSize(item.size)
                )
            }
            lineSubviews.removeAll()
        }

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                flushLine()
                currentX = 0
                currentY += lineHeight + verticalSpacing
                lineHeight = 0
            }

            lineSubviews.append((subview, size, currentX))
            currentX += size.width + horizontalSpacing
            lineHeight = max(lineHeight, size.height)
        }

        flushLine()
    }
}

#Preview("FlowLayout Demo") {
    VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
        Text("流式折行布局 (FlowLayout)")
            .font(DesignSystem.Typography.headline)

        FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(["SwiftUI", "iOS 18", "Structured", "多巴胺主题", "动效", "SF Pro Rounded", "浮岛卡片", "触感反馈", "设计系统"], id: \.self) { tag in
                Text(tag)
                    .font(DesignSystem.Typography.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(DesignSystem.Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
    }
    .padding()
    .background(DesignSystem.Color.background)
}
