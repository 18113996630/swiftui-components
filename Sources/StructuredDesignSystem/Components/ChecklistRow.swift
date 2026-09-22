import SwiftUI

/// 标杆级清单与待办行（Structured 风格，支持 @Environment(\.themePalette)）
/// 对应任务详情中的子任务清单卡片，支持复选框勾选、删除线动效与右侧清除按钮
public struct ChecklistRow: View {
    @Environment(\.themePalette) private var themePalette
    private let title: String
    @Binding private var isChecked: Bool
    private let customColor: Color?
    private let onDelete: (() -> Void)?

    public init(
        title: String,
        isChecked: Binding<Bool>,
        activeColor: Color? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.title = title
        self._isChecked = isChecked
        self.customColor = activeColor
        self.onDelete = onDelete
    }

    private var effectiveColor: Color {
        customColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            // 方形圆角复选框与主文本联动整行可点交互区
            Button(action: {
                HapticManager.impact(.light)
                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                    isChecked.toggle()
                }
            }) {
                HStack(spacing: DesignSystem.Spacing.medium) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .strokeBorder(isChecked ? effectiveColor : SwiftUI.Color.gray.opacity(0.35), lineWidth: 1.5)
                            .frame(width: 20, height: 20)

                        if isChecked {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(effectiveColor)
                                .frame(width: 20, height: 20)

                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 28, height: 28)

                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(isChecked ? DesignSystem.Color.textTertiary : DesignSystem.Color.textPrimary)
                        .strikethrough(isChecked, color: DesignSystem.Color.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            // 右侧删除/清除按键 (独立 32x32 触控靶心)
            if let onDelete {
                Button(action: {
                    HapticManager.impact(.light)
                    onDelete()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.Color.textTertiary)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

// MARK: - Previews
#Preview("ChecklistRow Preview") {
    ChecklistRowPreviewHelper()
}

private struct ChecklistRowPreviewHelper: View {
    @State private var item1 = true
    @State private var item2 = false
    @State private var item3 = false

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(spacing: 0) {
                        ChecklistRow(title: "开启通知提醒", isChecked: $item1, onDelete: {})
                        Divider()
                        ChecklistRow(title: "导入系统日历事件", isChecked: $item2, onDelete: {})
                        Divider()
                        ChecklistRow(title: "配置深浅色外观主题", isChecked: $item3, onDelete: {})
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
            .themePalette(.teal)
        }
    }
}
