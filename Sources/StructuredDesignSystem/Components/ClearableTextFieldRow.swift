import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// 带有一键清空与快捷粘贴的表单单行输入项（Structured 风格）
///
/// 严格对齐卡片排版规范：左侧标题 + 右侧文本输入框 + 浮现式清空按钮。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：标题与占位符文案纯由调用方传入，无内置业务字串；
/// 2. 【固定最小基线】：标题设置 `frame(minWidth: 70, alignment: .leading)`，确保多语言下表单对齐工整；
/// 3. 【清空微动效】：点击清空图标触发轻柔触感震动与 0.15s 平滑透明度淡出。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// ClearableTextFieldRow(
///     "field_api_key",
///     placeholder: "placeholder_enter_key",
///     text: $apiKey,
///     isSecure: true
/// )
///
/// // 2. 动态非本地化直出
/// ClearableTextFieldRow(
///     verbatim: "ID",
///     placeholder: "User ID",
///     text: $userId
/// )
/// ```
public struct ClearableTextFieldRow: View {
    private let title: LocalizedText
    private let placeholder: LocalizedText
    @Binding private var text: String
    private let isSecure: Bool
    private let showPasteButton: Bool

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        isSecure: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.title = .localized(title)
        self.placeholder = .localized(placeholder)
        self._text = text
        self.isSecure = isSecure
        self.showPasteButton = showPasteButton
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        isSecure: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.init(title, placeholder: placeholder, text: text, isSecure: isSecure, showPasteButton: showPasteButton)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.title = .verbatim(title)
        self.placeholder = .verbatim(placeholder)
        self._text = text
        self.isSecure = isSecure
        self.showPasteButton = showPasteButton
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            title.makeText()
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .frame(minWidth: 70, alignment: .leading)

            Group {
                if isSecure {
                    SecureField(text: $text, prompt: placeholder.makeText()) {
                        title.makeText()
                    }
                } else {
                    TextField(text: $text, prompt: placeholder.makeText()) {
                        title.makeText()
                    }
                }
            }
            .font(DesignSystem.Typography.body)
            .textFieldStyle(PlainTextFieldStyle())

            // 右侧动态功能按键
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
                        .frame(width: 32, height: 32)
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
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

#Preview("ClearableTextFieldRow Preview") {
    ClearableTextFieldPreviewHelper()
}

private struct ClearableTextFieldPreviewHelper: View {
    @State private var apiKey = "sk-ant-test-key-123456"
    @State private var endpoint = ""

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        ClearableTextFieldRow(
                            "API 密钥",
                            placeholder: "输入 sk- 开头的密钥",
                            text: $apiKey,
                            isSecure: true
                        )

                        Divider()

                        ClearableTextFieldRow(
                            title: "代理地址",
                            placeholder: "https://api.openai.com",
                            text: $endpoint,
                            showPasteButton: true
                        )
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
    }
}
