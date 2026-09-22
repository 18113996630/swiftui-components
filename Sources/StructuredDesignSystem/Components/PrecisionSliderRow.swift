import SwiftUI

/// 等宽数值微调滑杆行（Structured 风格）
/// 严格对齐表单行与卡片节奏：包含彩色图标、标题、等宽微胶囊数值标签与平滑滑杆
public struct PrecisionSliderRow: View {
    @Environment(\.themePalette) private var themePalette

    private let icon: String?
    private let iconColor: Color?
    private let title: String
    private let subtitle: String?
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let unit: String
    private let customTint: Color?

    public init(
        icon: String? = nil,
        iconColor: Color? = nil,
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1.0,
        unit: String = "",
        tintColor: Color? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.range = range
        self.step = step
        self.unit = unit
        self.customTint = tintColor
    }

    private var effectiveTint: Color {
        customTint ?? themePalette.color
    }

    private var formattedValue: String {
        if step.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))\(unit.isEmpty ? "" : " \(unit)")"
        } else {
            return String(format: "%.1f%@", value, unit.isEmpty ? "" : " \(unit)")
        }
    }

    public var body: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            // 顶端标题与数值展示区
            HStack(spacing: DesignSystem.Layout.iconTextSpacing) {
                if let icon {
                    IconBadge(
                        systemName: icon,
                        color: iconColor ?? effectiveTint,
                        size: DesignSystem.Iconography.sizeMedium
                    )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }

                Spacer()

                // 等宽数值微胶囊指示器
                Text(formattedValue)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundColor(effectiveTint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(effectiveTint.opacity(0.12))
                    .clipShape(Capsule())
            }

            // 平滑 Slider 微调轨道
            Slider(value: $value, in: range, step: step)
                .tint(effectiveTint)
                .onChange(of: value) { _, _ in
                    HapticManager.selection()
                }
        }
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

#Preview("PrecisionSliderRow Preview") {
    PrecisionSliderPreviewHelper()
}

private struct PrecisionSliderPreviewHelper: View {
    @State private var fontSize = 32.0
    @State private var scrollSpeed = 160.0

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                BaseCard {
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        PrecisionSliderRow(
                            icon: "textformat.size",
                            title: "字幕字号",
                            subtitle: "调节提词主文本的呈现大小",
                            value: $fontSize,
                            range: 16...72,
                            step: 1.0,
                            unit: "pt"
                        )

                        Divider()

                        PrecisionSliderRow(
                            icon: "speedometer",
                            iconColor: .orange,
                            title: "滚动语速",
                            subtitle: "每分钟口播词数基准",
                            value: $scrollSpeed,
                            range: 80...320,
                            step: 5.0,
                            unit: "WPM"
                        )
                    }
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
            .themePalette(.teal)
        }
    }
}
