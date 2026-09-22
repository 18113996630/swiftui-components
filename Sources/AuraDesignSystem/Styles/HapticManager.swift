import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// 集中式触觉与手感管理器（Haptic & Sensory Feedback）
/// 严格遵循 Apple HIG 规范，为各类交互提供干脆克制的物理振动回馈
@MainActor
public enum HapticManager {
    public enum ImpactWeight: Sendable {
        case light
        case medium
        case heavy
        case rigid
        case soft
    }

    public enum NotificationType: Sendable {
        case success
        case warning
        case error
    }

    /// 触发轻重不同的机械敲击反馈
    public static func impact(_ weight: ImpactWeight = .light) {
        #if canImport(UIKit)
        let style: UIImpactFeedbackGenerator.FeedbackStyle
        switch weight {
        case .light: style = .light
        case .medium: style = .medium
        case .heavy: style = .heavy
        case .rigid: style = .rigid
        case .soft: style = .soft
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }

    /// 触发状态通知类振动（成功、警告、错误）
    public static func notification(_ type: NotificationType) {
        #if canImport(UIKit)
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType
        switch type {
        case .success: feedbackType = .success
        case .warning: feedbackType = .warning
        case .error: feedbackType = .error
        }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(feedbackType)
        #endif
    }

    /// 触发滚轮/分段器/色盘切换时的细腻刻度步进感
    public static func selection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - View Modifiers
public extension View {
    /// 在布尔状态或数值变化时触发指定的振动反馈
    func hapticFeedback<T: Equatable>(
        trigger: T,
        weight: HapticManager.ImpactWeight = .light
    ) -> some View {
        onChange(of: trigger) { _, _ in
            HapticManager.impact(weight)
        }
    }
}
