import SwiftUI

/// 状态切换标签芯片（Structured 风格）
///
/// 支持单选/多选场景，选中态具备平滑 Spring 动效、勾选图标与触觉反馈。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：芯片不预设任何业务字串，纯由外部注入；
/// 2. 【状态动效与触感】：选中/反选过程强制触发 `HapticManager.selection()` 与弹性 Spring 过渡；
/// 3. 【无二次透明稀释】：选中态文字强制白底高对比，未选中态使用标准 `textPrimary`。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// SelectableChip("tag_video_script", isSelected: isSelected) {
///     isSelected.toggle()
/// }
///
/// // 2. 动态非本地化集合（Verbatim 直出）
/// ForEach(tags, id: \.self) { tag in
///     SelectableChip(verbatim: tag, isSelected: selectedSet.contains(tag)) {
///         toggleSelection(tag)
///     }
/// }
/// ```
public struct SelectableChip: View {
    @Environment(\.themePalette) private var themePalette

    private let title: LocalizedText
    private let isSelected: Bool
    private let icon: String?
    private let customTint: Color?
    private let onToggle: () -> Void

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        isSelected: Bool,
        icon: String? = nil,
        tintColor: Color? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.title = .localized(title)
        self.isSelected = isSelected
        self.icon = icon
        self.customTint = tintColor
        self.onToggle = onToggle
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        isSelected: Bool,
        icon: String? = nil,
        tintColor: Color? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.init(title, isSelected: isSelected, icon: icon, tintColor: tintColor, onToggle: onToggle)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        isSelected: Bool,
        icon: String? = nil,
        tintColor: Color? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.title = .verbatim(title)
        self.isSelected = isSelected
        self.icon = icon
        self.customTint = tintColor
        self.onToggle = onToggle
    }

    private var effectiveTint: Color {
        customTint ?? themePalette.color
    }

    public var body: some View {
        Button(action: {
            HapticManager.selection()
            withAnimation(.spring(response: 0.25, dampingFraction: 0.72)) {
                onToggle()
            }
        }) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .transition(.scale.combined(with: .opacity))
                } else if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }

                title.makeText()
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected ? effectiveTint : DesignSystem.Color.fillTertiary
            )
            .foregroundColor(
                isSelected ? .white : DesignSystem.Color.textPrimary
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
            .shadow(
                color: isSelected ? effectiveTint.opacity(0.25) : Color.clear,
                radius: 6,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(.scale)
    }
}

#Preview("SelectableChip Variations") {
    SelectableChipPreviewHelper()
}

private struct SelectableChipPreviewHelper: View {
    @State private var selected = Set(["短视频", "爆款脚本"])

    let tags = ["短视频", "爆款脚本", "带货提词", "AI改写", "宣发海报", "灵感速记"]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text("SelectableChip (可选择胶囊芯片)")
                .font(DesignSystem.Typography.headline)

            FlowLayout(horizontalSpacing: 8, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    SelectableChip(
                        verbatim: tag,
                        isSelected: selected.contains(tag)
                    ) {
                        if selected.contains(tag) {
                            selected.remove(tag)
                        } else {
                            selected.insert(tag)
                        }
                    }
                }
            }
        }
        .padding()
        .themePalette(.teal)
    }
}
