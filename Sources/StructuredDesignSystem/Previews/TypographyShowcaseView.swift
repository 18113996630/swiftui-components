import SwiftUI

/// 排版字阶与视觉对比度规范展示视图（Typography & Contrast Specimen）
/// 遵循 Apple HIG 规范与 WCAG 4.5:1 对比度标准，展示字级阶梯、语义黑白灰阶、Bad vs Good 实测及 Structured 标杆组件
public struct TypographyShowcaseView: View {
    @State private var selectedTheme = ThemePalette.teal
    @State private var sampleTaskDone = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                headerSection
                badVsGoodSection
                typeScaleSection
                semanticColorSection
                practicalComponentSection
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
        .background(DesignSystem.Color.background.ignoresSafeArea())
        .themePalette(selectedTheme)
    }

    // MARK: - 01 顶部标头
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Text("Typography System")
                    .font(DesignSystem.Typography.largeTitle)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                    Text("HIG · WCAG 4.5:1")
                }
                .font(DesignSystem.Typography.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(selectedTheme.color.opacity(0.15))
                .foregroundColor(selectedTheme.color)
                .clipShape(Capsule())
            }

            Text("排版字阶规范、语义对比度约束与 Structured 风格标杆实测")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textSecondary)
        }
    }

    // MARK: - 02 Bad vs Good 对比演示
    private var badVsGoodSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionHeader(title: "灰度对比度实测 (Bad vs Good)", icon: "circle.lefthalf.filled")

            HStack(spacing: DesignSystem.Spacing.medium) {
                // ❌ 错误做法：二次透明度稀释导致发灰
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("二次稀释 (Bad)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                    }

                    Text("48% 不透明度")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color.primary.opacity(0.48))

                    Text("对比度仅 2.5:1，在灰底上笔画严重发虚，产生蒙灰感。")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color.secondary.opacity(0.8)) // 48%
                        .lineSpacing(2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DesignSystem.Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )

                // ✅ 正确做法：高黑度骨架 + 黄金次级灰
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("HIG 黄金规范 (Good)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }

                    Text("60% 语义次级灰")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(DesignSystem.Color.textPrimary)

                    Text("对比度 4.6:1+，黑白分明，浮岛纯白承托，清晰通透。")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(DesignSystem.Color.textSecondary)
                        .lineSpacing(2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DesignSystem.Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }

    // MARK: - 03 官方字级阶梯
    private var typeScaleSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionHeader(title: "规范字级阶梯 (Type Scale)", icon: "textformat.size")

            BaseCard {
                VStack(spacing: 12) {
                    typeRow(label: "Large Title", spec: "28pt · Bold", font: DesignSystem.Typography.largeTitle, sample: "Structured 标题")
                    Divider().opacity(0.4)
                    typeRow(label: "Title", spec: "20pt · Bold", font: DesignSystem.Typography.title, sample: "卡片与模块主标")
                    Divider().opacity(0.4)
                    typeRow(label: "Headline", spec: "17pt · Semibold", font: DesignSystem.Typography.headline, sample: "章节导航与强调首行")
                    Divider().opacity(0.4)
                    typeRow(label: "Body", spec: "16pt · Regular", font: DesignSystem.Typography.body, sample: "正文阅读呼吸感与适读性")
                    Divider().opacity(0.4)
                    typeRow(label: "Subheadline", spec: "14pt · Medium", font: DesignSystem.Typography.subheadline, sample: "辅助说明与列表副标")
                    Divider().opacity(0.4)
                    typeRow(label: "Caption / Time", spec: "13pt · Medium/Semibold", font: DesignSystem.Typography.caption, sample: "09:00 - 10:00 · 标签微标")
                }
            }
        }
    }

    // MARK: - 04 语义黑白灰阶
    private var semanticColorSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionHeader(title: "4 层语义文本色阶 (Foreground Hierarchy)", icon: "paintpalette")

            BaseCard {
                VStack(spacing: 14) {
                    colorRow(
                        title: "Primary (主文本 / 100%)",
                        desc: "大标题、重点数字、主交互。浅色纯黑/深色纯白，建立绝对焦点。",
                        color: DesignSystem.Color.textPrimary,
                        sampleText: "设计系统核心大标题"
                    )
                    Divider().opacity(0.4)
                    colorRow(
                        title: "Secondary (次级文本 / 60%)",
                        desc: "正文说明、列表副标题。满足 WCAG 4.5:1 基准，严禁二次叠加 opacity。",
                        color: DesignSystem.Color.textSecondary,
                        sampleText: "次级说明文案，通透清晰不发虚"
                    )
                    Divider().opacity(0.4)
                    colorRow(
                        title: "Tertiary (弱文本 / 30%)",
                        desc: "仅用于 Placeholder 占位符、次要图标箭头。不可用于正文长句。",
                        color: DesignSystem.Color.textTertiary,
                        sampleText: "例如：请输入日程名称..."
                    )
                }
            }
        }
    }

    // MARK: - 05 实战组件效果
    private var practicalComponentSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionHeader(title: "Structured 标杆组件实装效果", icon: "square.stack.3d.up.fill")

            // 浮岛日程卡片
            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(selectedTheme.gradient)
                            .frame(width: 38, height: 38)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text("HIG 设计系统评审会议")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Color.textPrimary)

                            HStack(spacing: 6) {
                                Text("09:30 - 10:30")
                                    .font(DesignSystem.Typography.time)
                                    .foregroundColor(selectedTheme.color)

                                Text("· 1小时")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Color.textSecondary)
                            }
                        }

                        Spacer()

                        Button(action: {
                            sampleTaskDone.toggle()
                        }) {
                            Image(systemName: sampleTaskDone ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24))
                                .foregroundColor(sampleTaskDone ? .green : DesignSystem.Color.textSecondary)
                        }
                    }

                    Divider().opacity(0.4)

                    HStack {
                        PillBadge(title: "设计规范", style: .subtle(selectedTheme.color))
                        PillBadge(title: "已校准 4.5:1", style: .subtle(Color.green))
                        Spacer()
                        Text("全员参与")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - 辅助子视图
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(selectedTheme.color)

            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Color.textPrimary)

            Spacer()
        }
        .padding(.leading, 4)
    }

    private func typeRow(label: String, spec: String, font: Font, sample: String) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(sample)
                    .font(font)
                    .foregroundColor(DesignSystem.Color.textPrimary)
                Text(spec)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(selectedTheme.color)
            }
            Spacer()
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(DesignSystem.Color.textSecondary)
        }
    }

    private func colorRow(title: String, desc: String, color: Color, sampleText: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Color.textPrimary)
                Spacer()
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    )
            }

            Text(sampleText)
                .font(DesignSystem.Typography.body)
                .foregroundColor(color)

            Text(desc)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Color.textSecondary)
                .lineSpacing(2)
        }
    }
}

#Preview("Typography Showcase - Light") {
    TypographyShowcaseView()
        .preferredColorScheme(.light)
}

#Preview("Typography Showcase - Dark") {
    TypographyShowcaseView()
        .preferredColorScheme(.dark)
}
