import SwiftUI

/// 键盘上方快捷操作辅助栏（Structured 风格）
/// 常用于正文编辑、脚本预览、提示词编写等场景下的快捷工具链与字数统计
public struct KeyboardAccessoryBar: View {
    @Environment(\.themePalette) private var themePalette

    private let onPaste: (() -> Void)?
    private let onClear: (() -> Void)?
    private let wordCount: Int?
    private let onDone: () -> Void

    public init(
        onPaste: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        wordCount: Int? = nil,
        onDone: @escaping () -> Void
    ) {
        self.onPaste = onPaste
        self.onClear = onClear
        self.wordCount = wordCount
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

            // 实时等宽字数徽标
            if let wordCount {
                Text("\(wordCount) 字")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(DesignSystem.Color.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DesignSystem.Color.fillTertiary)
                    .clipShape(Capsule())
            }

            // 完成收起键盘按键
            Button(action: {
                HapticManager.impact(.light)
                onDone()
            }) {
                Text("完成")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(themePalette.color)
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
            onPaste: {},
            onClear: {},
            wordCount: 842,
            onDone: {}
        )
    }
    .themePalette(.indigo)
}
