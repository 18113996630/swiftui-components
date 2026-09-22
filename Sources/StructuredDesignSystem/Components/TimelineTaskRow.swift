import SwiftUI

/// Structured 标志性 38pt 饱满时间线任务节点行
///
/// 包含 38pt 饱满彩色圆形图标、时间跨度刻度、主副标题、分类微标与触觉打卡检查环。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【时间排版】：时间刻度统一采用 `DesignSystem.Typography.time` (13pt Semibold Rounded)，确保数字清脆笃定；
/// 2. 【多巴胺节点】：节点圆形背景强制采用饱满实心渐变或主色，配纯白图标，杜绝低饱和透明度混色发脏；
/// 3. 【正向完成反馈】：打卡按钮完成态采用温和正向绿 + 触觉震动反馈，未完成态采用柔和中性轮廓。
///
/// ```swift
/// TimelineTaskRow(
///     time: "09:30",
///     timeRange: "09:30 - 10:30 (1小时)",
///     title: "核心系统架构设计",
///     subtitle: "明确技术红线与容器边界",
///     icon: "laptopcomputer",
///     isCompleted: $taskCompleted
/// )
/// ```
public struct TimelineTaskRow: View {
    @Environment(\.themePalette) private var themePalette
    private let time: String
    private let timeRange: String?
    private let title: String
    private let subtitle: String?
    private let icon: String
    private let customColor: Color?
    private let tagTitle: String?
    private let tagIcon: String?
    private let isLast: Bool
    @Binding private var isCompleted: Bool

    public init(
        time: String,
        timeRange: String? = nil,
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: Color? = nil,
        tagTitle: String? = nil,
        tagIcon: String? = nil,
        isLast: Bool = false,
        isCompleted: Binding<Bool>? = nil
    ) {
        self.time = time
        self.timeRange = timeRange
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.customColor = color
        self.tagTitle = tagTitle
        self.tagIcon = tagIcon
        self.isLast = isLast
        self._isCompleted = isCompleted ?? .constant(false)
    }

    private var effectiveColor: Color {
        customColor ?? themePalette.color
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
            // 左侧时间标签
            Text(time)
                .font(DesignSystem.Typography.time)
                .foregroundColor(DesignSystem.Color.textTertiary)
                .frame(width: 44, alignment: .trailing)
                .padding(.top, 9)

            // 中间时间线节点与连接线
            VStack(spacing: 0) {
                // 38pt 饱满实心节点
                ZStack {
                    Circle()
                        .fill(effectiveColor)
                        .frame(width: DesignSystem.Iconography.sizeLarge, height: DesignSystem.Iconography.sizeLarge)
                        .shadow(color: effectiveColor.opacity(0.25), radius: 6, x: 0, y: 3)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }

                if !isLast {
                    Rectangle()
                        .fill(SwiftUI.Color.gray.opacity(0.18))
                        .frame(width: 2.5)
                        .frame(minHeight: 32)
                }
            }

            // 任务核心信息
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.tiny) {
                if let timeRange {
                    Text(timeRange)
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }

                Text(title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(isCompleted ? DesignSystem.Color.textTertiary : DesignSystem.Color.textPrimary)
                    .strikethrough(isCompleted, color: DesignSystem.Color.textTertiary)

                if let subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }

                if let tagTitle {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        PillButton(
                            title: tagTitle,
                            icon: tagIcon ?? "checklist",
                            action: {}
                        )

                        Image(systemName: "doc.text")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }
                    .padding(.top, DesignSystem.Spacing.tiny)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
            .padding(.bottom, isLast ? 0 : DesignSystem.Spacing.large)

            // 右侧极细打卡检查环
            Button(action: {
                if !isCompleted {
                    HapticManager.notification(.success)
                } else {
                    HapticManager.impact(.light)
                }
                withAnimation(DesignSystem.Motion.springAnimation) {
                    isCompleted.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            isCompleted ? effectiveColor : effectiveColor.opacity(0.45),
                            lineWidth: 1.2
                        )
                        .frame(width: 22, height: 22)

                    if isCompleted {
                        Circle()
                            .fill(effectiveColor)
                            .frame(width: 18, height: 18)

                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 8)
        }
    }
}

/// 标杆级空闲时段间隔行（Structured 虚线空档节律）
public struct TimelineGapRow: View {
    private let time: String?
    private let note: String

    public init(time: String? = nil, note: String) {
        self.time = time
        self.note = note
    }

    public var body: some View {
        HStack(alignment: .center, spacing: DesignSystem.Spacing.medium) {
            // 时间或占位
            if let time {
                Text(time)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Color.textTertiary.opacity(0.7))
                    .frame(width: 44, alignment: .trailing)
            } else {
                Spacer().frame(width: 44)
            }

            // 居中点状虚线
            VStack(spacing: 4) {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [3, 4]))
                    .foregroundColor(SwiftUI.Color.gray.opacity(0.3))
                    .frame(width: 2, height: 28)
            }
            .frame(width: DesignSystem.Iconography.sizeLarge)

            // 空闲时段提示
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 11))
                Text(note)
                    .font(DesignSystem.Typography.caption)
            }
            .foregroundColor(DesignSystem.Color.textTertiary)

            Spacer()
        }
    }
}

// 内部虚线绘制辅助 Shape
private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

// MARK: - Previews
#Preview("Timeline Flow") {
    TimelineFlowPreviewHelper()
}

private struct TimelineFlowPreviewHelper: View {
    @State private var task1Done = true
    @State private var task2Done = false
    @State private var task3Done = false

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    TimelineTaskRow(
                        time: "09:00",
                        timeRange: "09:00 - 10:00 (1小时)",
                        title: "准备早晨会议",
                        subtitle: "梳理今日核心目标与架构",
                        icon: "cup.and.saucer.fill",
                        color: ThemePalette.coral.color,
                        tagTitle: "0/3",
                        isCompleted: $task1Done
                    )

                    TimelineGapRow(
                        time: "10:00",
                        note: "保持充沛，适当休息 30 分钟"
                    )

                    TimelineTaskRow(
                        time: "10:30",
                        timeRange: "10:30 - 12:00 (1小时30分钟)",
                        title: "开始使用 Structured 架构",
                        subtitle: "编写基础组件与主题系统代码",
                        icon: "paintpalette.fill",
                        color: ThemePalette.berry.color,
                        tagTitle: "2/5",
                        isCompleted: $task2Done
                    )

                    TimelineTaskRow(
                        time: "12:00",
                        timeRange: "12:00 - 13:00 (1小时)",
                        title: "营养午餐与户外散步",
                        icon: "figure.walk",
                        color: ThemePalette.sage.color,
                        isLast: true,
                        isCompleted: $task3Done
                    )
                }
                .padding(DesignSystem.Layout.pagePadding)
            }
        }
    }
}
