import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// 带有一键清空与明密文切换的表单密文输入行（Aura 标杆风格）
///
/// 严格对齐卡片排版规范：左侧标题 + 右侧密文输入框 + 浮现式一键清空与明密文切换按键。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：标题与占位符文案纯由调用方传入，严禁内置业务字串；
/// 2. 【固定最小基线】：标题设置 `frame(minWidth: 70, alignment: .leading)`，确保多语言及不同表单项间严格左对齐；
/// 3. 【清空与显隐微动效】：点击清空或眼睛显隐切换图标触发轻柔触感震动（`HapticManager.impact(.light)`）与平滑状态切换。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// ClearableSecureFieldRow(
///     "field_password",
///     placeholder: "placeholder_enter_password",
///     text: $password,
///     allowReveal: true
/// )
///
/// // 2. 动态非本地化直出
/// ClearableSecureFieldRow(
///     verbatim: "Token",
///     placeholder: "Access Token",
///     text: $token
/// )
/// ```
public struct ClearableSecureFieldRow: View {
    private let title: LocalizedText
    private let placeholder: LocalizedText
    @Binding private var text: String
    private let allowReveal: Bool
    private let showPasteButton: Bool

    @State private var isRevealed: Bool = false

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        allowReveal: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.title = .localized(title)
        self.placeholder = .localized(placeholder)
        self._text = text
        self.allowReveal = allowReveal
        self.showPasteButton = showPasteButton
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        allowReveal: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.init(title, placeholder: placeholder, text: text, allowReveal: allowReveal, showPasteButton: showPasteButton)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        placeholder: String,
        text: Binding<String>,
        allowReveal: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.title = .verbatim(title)
        self.placeholder = .verbatim(placeholder)
        self._text = text
        self.allowReveal = allowReveal
        self.showPasteButton = showPasteButton
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            title.makeText()
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .frame(minWidth: 70, alignment: .leading)

            Group {
                if isRevealed {
                    TextField(text: $text, prompt: placeholder.makeText()) {
                        title.makeText()
                    }
                } else {
                    SecureField(text: $text, prompt: placeholder.makeText()) {
                        title.makeText()
                    }
                }
            }
            .font(DesignSystem.Typography.body)
            .textFieldStyle(PlainTextFieldStyle())

            // 右侧动态按键组
            HStack(spacing: 4) {
                if allowReveal && !text.isEmpty {
                    Button(action: {
                        HapticManager.impact(.light)
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isRevealed.toggle()
                        }
                    }) {
                        Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 14))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                            .frame(width: 30, height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if !text.isEmpty {
                    Button(action: {
                        HapticManager.impact(.light)
                        withAnimation(.easeInOut(duration: 0.15)) {
                            text = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                            .frame(width: 30, height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                } else if showPasteButton {
                    Button(action: {
                        #if canImport(UIKit)
                        if let string = UIPasteboard.general.string {
                            HapticManager.impact(.light)
                            withAnimation {
                                text = string
                            }
                        }
                        #endif
                    }) {
                        Image(systemName: "doc.on.clipboard")
                            .font(.system(size: 14))
                            .foregroundColor(DesignSystem.Color.textSecondary)
                            .frame(width: 32, height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

#Preview("ClearableSecureFieldRow Preview") {
    ClearableSecureFieldPreviewHelper()
}

private struct ClearableSecureFieldPreviewHelper: View {
    @State private var password = "super_secret_token_8899"
    @State private var pinCode = ""

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        ClearableSecureFieldRow(
                            "访问密钥",
                            placeholder: "输入秘钥",
                            text: $password,
                            allowReveal: true
                        )

                        Divider()

                        ClearableSecureFieldRow(
                            title: "支付密码",
                            placeholder: "6位数字",
                            text: $pinCode,
                            showPasteButton: true
                        )
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
    }
}
