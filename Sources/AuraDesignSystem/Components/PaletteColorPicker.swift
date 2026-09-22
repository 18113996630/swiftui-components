import SwiftUI

/// 原子级同心双环取色点（Aura 标杆设计规范）
/// 规范严格要求：中心实心色块 + 透明微间隙 + 极细同色光环描边，杜绝粗生硬边框与发脏杂色
public struct ConcentricColorCircle: View {
    public let color: Color
    public let isSelected: Bool
    public var diameter: CGFloat
    public let onSelect: () -> Void

    public init(
        color: Color,
        isSelected: Bool,
        diameter: CGFloat = 38,
        onSelect: @escaping () -> Void
    ) {
        self.color = color
        self.isSelected = isSelected
        self.diameter = diameter
        self.onSelect = onSelect
    }

    public var body: some View {
        Button(action: {
            guard !isSelected else { return }
            HapticManager.selection()
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                onSelect()
            }
        }) {
            ZStack {
                // 选中态同心外光晕描边环
                if isSelected {
                    Circle()
                        .strokeBorder(color, lineWidth: 2)
                        .frame(width: diameter, height: diameter)

                    Circle()
                        .fill(DesignSystem.Color.surfaceBackground)
                        .frame(width: max(0, diameter - 6), height: max(0, diameter - 6))
                }

                // 实体色彩核心圆
                Circle()
                    .fill(color)
                    .frame(
                        width: isSelected ? max(0, diameter - 12) : max(0, diameter - 8),
                        height: isSelected ? max(0, diameter - 12) : max(0, diameter - 8)
                    )
                    .shadow(
                        color: color.opacity(0.3),
                        radius: isSelected ? 4 : 2,
                        x: 0,
                        y: 2
                    )
            }
            .frame(width: max(44, diameter + 4), height: max(44, diameter + 4))
            .contentShape(Circle())
        }
        .buttonStyle(.scale)
    }
}

/// 通用调色盘拾取行（支持任意 Color 集合）
public struct ColorPickerRow: View {
    @Binding private var selectedColor: Color
    private let colors: [Color]
    private let itemDiameter: CGFloat

    public init(
        selectedColor: Binding<Color>,
        colors: [Color],
        itemDiameter: CGFloat = 36
    ) {
        self._selectedColor = selectedColor
        self.colors = colors
        self.itemDiameter = itemDiameter
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                    ConcentricColorCircle(
                        color: color,
                        isSelected: selectedColor == color,
                        diameter: itemDiameter
                    ) {
                        selectedColor = color
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.tiny)
            .padding(.vertical, 4)
        }
    }
}

/// 标杆级 9 色多巴胺活力主题色盘拾取器（Aura 风格，与 ThemePalette 绑定）
public struct PaletteColorPicker: View {
    @Binding private var selectedPalette: ThemePalette
    private let palettes: [ThemePalette]

    public init(
        selectedPalette: Binding<ThemePalette>,
        palettes: [ThemePalette] = ThemePalette.allCases
    ) {
        self._selectedPalette = selectedPalette
        self.palettes = palettes
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(palettes) { palette in
                    ConcentricColorCircle(
                        color: palette.color,
                        isSelected: selectedPalette == palette,
                        diameter: 38
                    ) {
                        selectedPalette = palette
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.tiny)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Previews
#Preview("PaletteColorPicker & ConcentricCircle") {
    PaletteColorPickerPreviewHelper()
}

private struct PaletteColorPickerPreviewHelper: View {
    @State private var currentTheme: ThemePalette = .berry
    @State private var customColor: Color = .purple

    private let sampleColors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink]

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        HStack {
                            Text("主题色盘拾取 (9色多巴胺)")
                                .font(DesignSystem.Typography.headline)
                            Spacer()
                            Text(currentTheme.title)
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(currentTheme.color)
                        }

                        PaletteColorPicker(selectedPalette: $currentTheme)
                    }
                }

                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("通用色彩拾取行 (ColorPickerRow)")
                            .font(DesignSystem.Typography.headline)

                        ColorPickerRow(selectedColor: $customColor, colors: sampleColors)
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
    }
}
