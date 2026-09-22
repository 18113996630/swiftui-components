import SwiftUI

/// Structured 标杆级页面脚手架全景预览视图（StructuredScaffold & StructuredSection Demo）
///
/// 演示标准页面容器（StructuredScaffold）与段落分组（StructuredSection）的协同装配范式，
/// 包含 16pt 外边距、24pt 段落呼吸节奏、纯白浮岛卡片（BaseCard）承托与多巴胺主题穿透换肤。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【顶层脚手架】：整页必须以 `StructuredScaffold` 为根视图；
/// 2. 【分段规范】：各业务模块以 `StructuredSection` 分割，自动遵循 24pt 纵向呼吸节奏；
/// 3. 【正文入仓】：长段文字必须包装在 `BaseCard` 纯白浮岛中。
public struct ScaffoldShowcaseView: View {
    @State private var selectedTheme: ThemePalette = .teal
    @State private var taskDone = false
    @State private var notifyEnabled = true
    @State private var autoSync = true

    public init() {}

    public var body: some View {
        StructuredScaffold {
            // 顶部标题
            themeHeaderBanner

            // 段落 1：核心日程时间线
            StructuredSection(
                title: "今日日程轨道",
                icon: "calendar.badge.clock",
                badgeText: "进行中"
            ) {
                Button("全量日历") {}
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(selectedTheme.color)
            } content: {
                BaseCard {
                    TimelineTaskRow(
                        time: "09:30",
                        timeRange: "09:30 - 10:30 (1小时)",
                        title: "HIG 结构化设计系统落地",
                        subtitle: "确立页面脚手架与段落容器规范",
                        icon: "laptopcomputer",
                        color: selectedTheme.color,
                        tagTitle: "高优先级",
                        isCompleted: $taskDone
                    )
                }
            }

            // 段落 2：参数配置表单组
            StructuredSection(
                title: "个性化设置",
                icon: "gearshape.fill",
                badgeText: "已保存"
            ) {
                BaseCard {
                    VStack(spacing: 0) {
                        SettingsRow(
                            icon: "bell.badge.fill",
                            iconColor: .orange,
                            title: "日程通知提醒",
                            subtitle: "在任务开始前 15 分钟发送轻柔触感通知"
                        ) {
                            Toggle("", isOn: $notifyEnabled)
                                .labelsHidden()
                        }

                        Divider()
                            .padding(.leading, 38)
                            .opacity(0.3)

                        SettingsRow(
                            icon: "arrow.triangle.2.circlepath",
                            iconColor: selectedTheme.color,
                            title: "多端实时同步",
                            subtitle: "通过 CloudKit 自动同步日程与配置"
                        ) {
                            Toggle("", isOn: $autoSync)
                                .labelsHidden()
                        }
                    }
                }
            }

            // 段落 3：多巴胺活力主题色盘
            StructuredSection(
                title: "多巴胺主题换肤",
                icon: "paintpalette.fill",
                badgeVerbatim: selectedTheme.title
            ) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        PaletteColorPicker(selectedPalette: $selectedTheme)

                        Text("点击任意色彩即时穿透整页微标、时间线节点与交互控件。")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }
            }
        }
        .themePalette(selectedTheme)
    }

    private var themeHeaderBanner: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Text("Structured Scaffold")
                    .font(DesignSystem.Typography.largeTitle)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Spacer()

                PillBadge(title: "Scaffold & Section", style: .subtle(selectedTheme.color))
            }

            Text("标准页面脚手架与段落容器协同运作，自动锁死 16pt 页面边距与 24pt 段落呼吸节奏。")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textSecondary)
        }
        .padding(.horizontal, DesignSystem.Spacing.tiny)
    }
}

#Preview("Scaffold Showcase - Light") {
    ScaffoldShowcaseView()
        .preferredColorScheme(.light)
}

#Preview("Scaffold Showcase - Dark") {
    ScaffoldShowcaseView()
        .preferredColorScheme(.dark)
}
