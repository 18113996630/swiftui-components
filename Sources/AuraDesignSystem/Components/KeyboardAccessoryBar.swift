import SwiftUI

/// 键盘上方快捷操作辅助栏（Aura 风格）
///
/// 常用于正文编辑、脚本预览、提示词编写等场景下的快捷工具链与字数/Token统计。
/// 严格遵循状态与功能优先以图标表达的零硬编码原则，支持全量国际化与纯图标紧凑模式。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：完成按键不内置任何特定语言文本；未传入 `doneTitle` 时自动降级为系统级键盘收起图标（`keyboard.chevron.compact.down`）；
/// 2. 【计数器格式中立】：不写死“字”或“words”等语言量词，计数标签统一由外部传入 `counterText` 或纯数字展示；
/// 3. 【触觉反馈连贯】：所有按键默认绑定 `HapticManager.impact(.light)` 与 `.scale` 物理弹性触感。
///
/// ```swift
/// // 1. 本地化完成文案（Xcode 自动提取）
/// KeyboardAccessoryBar(
///     doneTitle: "keyboard_done",
///     counterText: "1,240 字符",
///     onDone: { hideKeyboard() }
/// )
///
/// // 2. 纯图标通用模式（0 语言文案，适合全球化多语言）
/// KeyboardAccessoryBar(
///     counterVerbatim: "842",
///     onPaste: { paste() },
///     onClear: { clear() },
///     onDone: { hideKeyboard() }
/// )
/// ```
public struct KeyboardAccessoryBar: View {
    @Environment(\.themePalette) private var themePalette

    private let doneTitle: LocalizedText?
    private let counterText: LocalizedText?
    private let onPaste: (() -> Void)?
    private let onClear: (() -> Void)?
    private let onDone: () -> Void

    /// 本地化初始化器
    public init(
        doneTitle: LocalizedStringKey? = nil,
        counterText: LocalizedStringKey? = nil,
        counterVerbatim: String? = nil,
        onPaste: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        onDone: @escaping () -> Void
    ) {
        self.doneTitle = doneTitle.map { .localized($0) }
        if let counterText {
            self.counterText = .localized(counterText)
        } else if let counterVerbatim {
            self.counterText = .verbatim(counterVerbatim)
        } else {
            self.counterText = nil
        }
        self.onPaste = onPaste
        self.onClear = onClear
        self.onDone = onDone
    }

    /// 数字计数器便捷初始化器（以中立纯数字或指定量词显示）
    public init(
        wordCount: Int? = nil,
        doneTitle: LocalizedStringKey? = nil,
        onPaste: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        onDone: @escaping () -> Void
    ) {
        self.init(
            doneTitle: doneTitle,
            counterVerbatim: wordCount.map { "\($0)" },
            onPaste: onPaste,
            onClear: onClear,
            onDone: onDone
        )
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatimDoneTitle: String,
        counterVerbatim: String? = nil,
        onPaste: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        onDone: @escaping () -> Void
    ) {
        self.doneTitle = .verbatim(verbatimDoneTitle)
        self.counterText = counterVerbatim.map { .verbatim($0) }
        self.onPaste = onPaste
        self.onClear = onClear
        self.onDone = onDone
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            // 左侧快捷操作
            if let onPaste {
                Button(action: {
                    HapticManager.impact(.light)
                    onPaste()
                }) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 15))
                }
                .buttonStyle(.scale)
            }

            if let onClear {
                Button(action: {
                    HapticManager.impact(.light)
                    onClear()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 15))
                }
                .buttonStyle(.scale)
            }

            Spacer()

            // 实时等宽计数徽标
            if let counterText {
                counterText.makeText()
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(DesignSystem.Color.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DesignSystem.Color.fillTertiary)
                    .clipShape(Capsule())
            }

            // 完成/收起键盘按键
            Button(action: {
                HapticManager.impact(.light)
                onDone()
            }) {
                if let doneTitle {
                    doneTitle.makeText()
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(themePalette.color)
                } else {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(themePalette.color)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
            }
            .buttonStyle(.scale)
        }
        .padding(.horizontal, DesignSystem.Layout.pagePadding)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

#Preview("KeyboardAccessoryBar Preview") {
    VStack {
        Spacer()
        KeyboardAccessoryBar(
            doneTitle: "完成",
            counterText: "842 字符",
            onPaste: {},
            onClear: {},
            onDone: {}
        )
    }
    .themePalette(.indigo)
}
