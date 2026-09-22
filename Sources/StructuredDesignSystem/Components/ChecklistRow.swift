import SwiftUI

/// 标杆级清单与待办行（Structured 风格，支持 @Environment(\.themePalette)）
///
/// 对应任务详情中的子任务清单卡片，支持复选框勾选、删除线动效与右侧清除按钮。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：待办条目标题纯由调用方显式注入；
/// 2. 【复选框动效】：勾选状态切换必须联动 Spring 动画与轻微震动反馈；
/// 3. 【删除线弱化】：完成态文字降级为 `textTertiary` 并附加中划线。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// ChecklistRow("task_notification_toggle", isChecked: $itemDone)
///
/// // 2. 动态任务清单（Verbatim 直出）
/// ChecklistRow(verbatim: dynamicTodo.title, isChecked: $dynamicTodo.isDone)
/// ```
public struct ChecklistRow: View {
    @Environment(\.themePalette) private var themePalette
    private let title: LocalizedText
    @Binding private var isChecked: Bool
    private let customColor: Color?
    private let onDelete: (() -> Void)?

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        isChecked: Binding<Bool>,
        activeColor: Color? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.title = .localized(title)
        self._isChecked = isChecked
        self.customColor = activeColor
        self.onDelete = onDelete
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        isChecked: Binding<Bool>,
        activeColor: Color? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.init(title, isChecked: isChecked, activeColor: activeColor, onDelete: onDelete)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        isChecked: Binding<Bool>,
        activeColor: Color? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.title = .verbatim(title)
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

                    title.makeText()
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
                        ChecklistRow("开启通知提醒", isChecked: $item1, onDelete: {})
                        Divider()
                        ChecklistRow("导入系统日历事件", isChecked: $item2, onDelete: {})
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
