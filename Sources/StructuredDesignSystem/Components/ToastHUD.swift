import SwiftUI

/// 原生毛玻璃悬浮轻提示胶囊（Structured 标杆风格）
/// 严格贴合悬浮胶囊规范：.ultraThinMaterial + 漫反射软阴影 + 0.5pt 细微边缘高光 + 自动延时消隐
public struct ToastHUD: View {
    @Environment(\.themePalette) private var themePalette

    private let message: String
    private let icon: String
    private let iconColor: Color?

    public init(
        message: String,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil
    ) {
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
    }

    private var effectiveIconColor: Color {
        iconColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(effectiveIconColor)

            Text(message)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Color.textPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(
            color: DesignSystem.Shadow.ambient.color,
            radius: DesignSystem.Shadow.ambient.radius,
            x: DesignSystem.Shadow.ambient.x,
            y: DesignSystem.Shadow.ambient.y
        )
    }
}

// MARK: - 声明式 View 修饰符扩展
public extension View {
    /// 为任意视图挂载声明式 Toast 浮窗轻提示
    /// - Parameters:
    ///   - isPresented: 双向绑定显隐状态
    ///   - message: 提示文本
    ///   - icon: 图标名称，默认 `checkmark.circle.fill`
    ///   - iconColor: 图标颜色，默认取当前主题色
    ///   - duration: 显示时长（秒），默认 2.0 秒后自动收起
    func toastHUD(
        isPresented: Binding<Bool>,
        message: String,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil,
        duration: Double = 2.0
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                VStack {
                    ToastHUD(message: message, icon: icon, iconColor: iconColor)
                        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.95)))
                        .padding(.top, 16)
                    Spacer()
                }
                .zIndex(999)
                .onAppear {
                    HapticManager.notification(.success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.76), value: isPresented.wrappedValue)
    }
}

#Preview("ToastHUD Preview") {
    ToastHUDPreviewHelper()
}

private struct ToastHUDPreviewHelper: View {
    @State private var showToast = false

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                Button("触发 Toast 轻提示") {
                    showToast = true
                }
                .buttonStyle(.scale)
                .padding()
                .background(ThemePalette.berry.color)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .toastHUD(isPresented: $showToast, message: "文稿已成功存入爆款智库")
        .themePalette(.berry)
    }
}
