import SwiftUI
import UIKit

/// 提供带有缩放、透明度变化和触觉反馈的按钮样式
public struct ScaleButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? DesignSystem.Motion.pressScale : 1)
            .opacity(configuration.isPressed ? DesignSystem.Motion.pressOpacity : 1)
            .animation(DesignSystem.Motion.standardAnimation, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                guard isPressed else { return }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
    }
}
