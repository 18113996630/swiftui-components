import SwiftUI

/// 原生毛玻璃悬浮轻提示胶囊（Aura 标杆风格）
///
/// 严格贴合悬浮胶囊规范：.ultraThinMaterial + 漫反射软阴影 + 0.5pt 细微边缘高光 + 自动延时消隐。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：提示信息纯由调用方传入，无内置文案；
/// 2. 【触觉反馈连贯】：浮出时自动触发 `HapticManager.notification(.success)`；
/// 3. 【无二次透明稀释】：胶囊文本使用标准 `textPrimary`，在毛玻璃材质上保持高对比度。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// .toastHUD(isPresented: $showToast, "toast_saved_success")
///
/// // 2. 动态非本地化直出
/// .toastHUD(isPresented: $showToast, verbatim: "Updated \(item.name)")
/// ```
public struct ToastHUD: View {
    @Environment(\.themePalette) private var themePalette

    private let message: LocalizedText
    private let icon: String
    private let iconColor: Color?

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ message: LocalizedStringKey,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil
    ) {
        self.message = .localized(message)
        self.icon = icon
        self.iconColor = iconColor
    }

    /// 具名本地化初始化器
    public init(
        message: LocalizedStringKey,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil
    ) {
        self.init(message, icon: icon, iconColor: iconColor)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim message: String,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil
    ) {
        self.message = .verbatim(message)
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

            message.makeText()
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
    /// 为任意视图挂载声明式 Toast 浮窗轻提示（本地化支持）
    func toastHUD(
        isPresented: Binding<Bool>,
        _ message: LocalizedStringKey,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil,
        duration: Double = 2.0
    ) -> some View {
        toastHUD(isPresented: isPresented, message: message, icon: icon, iconColor: iconColor, duration: duration)
    }

    /// 为任意视图挂载声明式 Toast 浮窗轻提示（具名本地化）
    func toastHUD(
        isPresented: Binding<Bool>,
        message: LocalizedStringKey,
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

    /// 为任意视图挂载声明式 Toast 浮窗轻提示（动态非本地化 Verbatim 直出）
    func toastHUD(
        isPresented: Binding<Bool>,
        verbatim message: String,
        icon: String = "checkmark.circle.fill",
        iconColor: Color? = nil,
        duration: Double = 2.0
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                VStack {
                    ToastHUD(verbatim: message, icon: icon, iconColor: iconColor)
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
        .toastHUD(isPresented: $showToast, "文稿已成功存入爆款智库")
        .themePalette(.berry)
    }
}
