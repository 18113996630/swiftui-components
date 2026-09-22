import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// 带有一键清空与快捷粘贴的表单单行输入项（Structured 风格）
/// 严格对齐卡片排版规范：左侧标题 + 右侧文本输入框 + 浮现式清空按钮
public struct ClearableTextFieldRow: View {
    private let title: String
    private let placeholder: String
    @Binding private var text: String
    private let isSecure: Bool
    private let showPasteButton: Bool

    public init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        showPasteButton: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.showPasteButton = showPasteButton
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .frame(minWidth: 70, alignment: .leading)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
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
                            title: "接口地址",
                            placeholder: "https://api.openai.com/v1",
                            text: $endpoint,
                            showPasteButton: true
                        )

                        Divider()

                        ClearableTextFieldRow(
                            title: "API Key",
                            placeholder: "填写以 sk- 开头的密钥",
                            text: $apiKey,
                            isSecure: true
                        )
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
    }
}
