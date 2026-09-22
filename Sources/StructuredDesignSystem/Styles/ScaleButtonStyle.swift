import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// 提供带有弹性物理缩放、透明度变化和触觉反馈的按钮样式（Structured 风格）
public struct ScaleButtonStyle: ButtonStyle {
    public var pressedScale: CGFloat
    public var pressedOpacity: Double

    public init(
        pressedScale: CGFloat = DesignSystem.Motion.pressScale,
        pressedOpacity: Double = DesignSystem.Motion.pressOpacity
    ) {
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(DesignSystem.Motion.standardAnimation, value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed) { _, isPressed in
                isPressed
            }
    }
}

public extension ButtonStyle where Self == ScaleButtonStyle {
    /// 默认 Structured 弹性微缩手感 (0.97 缩放)
    static var scale: ScaleButtonStyle { .init() }

    /// 自定义缩放比例与透明度手感
    static func scale(
        scale: CGFloat,
        opacity: Double = DesignSystem.Motion.pressOpacity
    ) -> ScaleButtonStyle {
        ScaleButtonStyle(pressedScale: scale, pressedOpacity: opacity)
    }
}

#Preview("Scale Button Style") {
    VStack(spacing: DesignSystem.Spacing.large) {
        Button(action: {}) {
            Text("标准弹性按压 (0.97)")
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(DesignSystem.Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
        }
        .buttonStyle(.scale)

        Button(action: {}) {
            HStack(spacing: DesignSystem.Spacing.small) {
                Image(systemName: "sparkles")
                Text("强按压微动效 (0.93)")
            }
            .font(DesignSystem.Typography.body)
            .foregroundColor(DesignSystem.Color.primary)
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.small)
            .background(DesignSystem.Color.primaryLight)
            .clipShape(Capsule())
        }
        .buttonStyle(.scale(scale: 0.93))
    }
    .padding(DesignSystem.Layout.pagePadding)
}
