import SwiftUI

public extension View {
    /// 快速包装为 Aura 风格浮岛卡片（自带连续曲率与漫反射微光阴影）
    /// - Parameters:
    ///   - cornerRadius: 圆角半径，默认 `DesignSystem.CornerRadius.largeCard` (28pt)
    ///   - padding: 内部边距，默认 `DesignSystem.Layout.cardPadding` (20pt)
    ///   - backgroundColor: 背景色彩，默认 `DesignSystem.Color.cardBackground`
    ///   - showBorder: 是否显示 0.5pt 细微边缘高光描边，默认 false
    ///   - shadow: 阴影规范，默认 `DesignSystem.Shadow.ambient`
    func auraCard(
        cornerRadius: CGFloat = DesignSystem.CornerRadius.largeCard,
        padding: CGFloat = DesignSystem.Layout.cardPadding,
        backgroundColor: Color = DesignSystem.Color.cardBackground,
        showBorder: Bool = false,
        shadow: ShadowStyle = DesignSystem.Shadow.ambient
    ) -> some View {
        self
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        showBorder ? Color.primary.opacity(0.06) : Color.clear,
                        lineWidth: 0.5
                    )
            )
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }

    /// 快速包装为浮岛卡片（已废弃，请迁移至 `.auraCard(...)`）
    @available(*, deprecated, renamed: "auraCard")
    func structuredCard(
        cornerRadius: CGFloat = DesignSystem.CornerRadius.largeCard,
        padding: CGFloat = DesignSystem.Layout.cardPadding,
        backgroundColor: Color = DesignSystem.Color.cardBackground,
        showBorder: Bool = false,
        shadow: ShadowStyle = DesignSystem.Shadow.ambient
    ) -> some View {
        auraCard(
            cornerRadius: cornerRadius,
            padding: padding,
            backgroundColor: backgroundColor,
            showBorder: showBorder,
            shadow: shadow
        )
    }

    /// 应用超柔和漫反射环境光阴影（Floating Ambient Shadow）
    func ambientShadow(_ style: ShadowStyle = DesignSystem.Shadow.ambient) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }

    /// 应用高层级悬浮弥散阴影（High Elevated Shadow）
    func floatingShadow(_ style: ShadowStyle = DesignSystem.Shadow.floating) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }

    /// 添加 0.5pt 细腻收敛的连续曲率超椭圆微描边（提升在浅灰底上的边缘高光精致度）
    /// - Parameters:
    ///   - color: 描边颜色，默认使用浅灰透明描边
    ///   - cornerRadius: 对应圆角，默认 28pt
    ///   - width: 描边线宽，默认 0.5pt
    func hairlineBorder(
        _ color: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = DesignSystem.CornerRadius.largeCard,
        width: CGFloat = 0.5
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(color, lineWidth: width)
        )
    }

    /// 便捷按压缩放手感微修饰符（缩放 0.97 + 触感）
    func scaleOnPress(action: (() -> Void)? = nil) -> some View {
        Button(action: { action?() }) {
            self
        }
        .buttonStyle(.scale)
    }

    /// 为横向或纵向滚动容器边缘注入平滑渐变消隐遮罩（防止悬浮控件重叠时的生硬截断）
    /// - Parameters:
    ///   - edge: 消隐边缘，默认 `.trailing`
    ///   - length: 渐变过渡长度，默认 `24pt`
    func fadeEdge(
        edge: Edge = .trailing,
        length: CGFloat = 24
    ) -> some View {
        self.mask(
            GeometryReader { proxy in
                let size = proxy.size
                switch edge {
                case .trailing:
                    HStack(spacing: 0) {
                        Rectangle().fill(Color.black)
                        LinearGradient(
                            colors: [Color.black, Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: min(length, size.width))
                    }
                case .leading:
                    HStack(spacing: 0) {
                        LinearGradient(
                            colors: [Color.clear, Color.black],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: min(length, size.width))
                        Rectangle().fill(Color.black)
                    }
                case .top:
                    VStack(spacing: 0) {
                        LinearGradient(
                            colors: [Color.clear, Color.black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: min(length, size.height))
                        Rectangle().fill(Color.black)
                    }
                case .bottom:
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.black)
                        LinearGradient(
                            colors: [Color.black, Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: min(length, size.height))
                    }
                }
            }
        )
    }
}
