import SwiftUI

/// 标杆级软底胶囊分段选择器（Aura 风格，支持 @Environment(\.themePalette)）
///
/// 彻底去除原生 UISegmentedControl 的硬金属反光，采用平滑滑块与触觉反馈。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：分段器选项文案由调用方通过闭包生成，无内置文本；
/// 2. 【去金属质感】：底板采用 `fillTertiary` 软底，禁用系统默认带反光的高光灰底；
/// 3. 【弹簧几何匹配】：选中滑块使用 `.matchedGeometryEffect` 与 `Spring` 动效驱动；
/// 4. 【字阶对齐 HIG 规范】：选项文字采用 `DesignSystem.Typography.footnote` (13pt Semibold/Medium)，杜绝大字撑爆分段滑块。
///
/// ```swift
/// // 1. 本地化映射（Xcode 自动提取）
/// PillSegmentedPicker(
///     selection: $mode,
///     items: AppMode.allCases,
///     titleKeyForSelection: { $0.localizationKey }
/// )
///
/// // 2. 动态非本地化映射
/// PillSegmentedPicker(
///     selection: $tab,
///     items: tabs,
///     titleForSelection: { $0.name }
/// )
/// ```
public struct PillSegmentedPicker<Selection: Hashable>: View {
    @Environment(\.themePalette) private var themePalette
    @Binding private var selection: Selection
    private let items: [Selection]
    private let textForSelection: (Selection) -> LocalizedText
    private let customActiveColor: Color?
    @Namespace private var animationNamespace

    /// 本地化初始化器（支持 String Catalog 静态提取）
    public init(
        selection: Binding<Selection>,
        items: [Selection],
        activeColor: Color? = nil,
        titleKeyForSelection: @escaping (Selection) -> LocalizedStringKey
    ) {
        self._selection = selection
        self.items = items
        self.customActiveColor = activeColor
        self.textForSelection = { .localized(titleKeyForSelection($0)) }
    }

    /// 动态非本地化直出初始化器
    public init(
        selection: Binding<Selection>,
        items: [Selection],
        activeColor: Color? = nil,
        titleForSelection: @escaping (Selection) -> String
    ) {
        self._selection = selection
        self.items = items
        self.customActiveColor = activeColor
        self.textForSelection = { .verbatim(titleForSelection($0)) }
    }

    private var effectiveActiveColor: Color {
        customActiveColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(items, id: \.self) { item in
                let isSelected = selection == item

                Button(action: {
                    guard selection != item else { return }
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.76)) {
                        selection = item
                    }
                }) {
                    textForSelection(item).makeText()
                        .font(DesignSystem.Typography.footnote)
                        .fontWeight(isSelected ? .semibold : .medium)
                        .foregroundColor(isSelected ? .white : DesignSystem.Color.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                                        .fill(effectiveActiveColor)
                                        .matchedGeometryEffect(id: "ActiveSegmentBackground", in: animationNamespace)
                                        .shadow(color: effectiveActiveColor.opacity(0.28), radius: 6, x: 0, y: 3)
                                }
                            }
                        )
                        .contentShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(DesignSystem.Color.fillTertiary)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button + 4, style: .continuous))
    }
}

#Preview("PillSegmentedPicker Preview") {
    PillSegmentedPickerPreviewHelper()
}

private struct PillSegmentedPickerPreviewHelper: View {
    enum ThemeMode: String, CaseIterable {
        case full = "完整"
        case light = "浅色"
        case dark = "深色"
    }

    @State private var selectedMode: ThemeMode = .full

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("外观主题")
                            .font(DesignSystem.Typography.headline)

                        PillSegmentedPicker(
                            selection: $selectedMode,
                            items: ThemeMode.allCases,
                            titleForSelection: { $0.rawValue }
                        )

                        Text("当前选择: \(selectedMode.rawValue)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
            .themePalette(.amber)
        }
    }
}
