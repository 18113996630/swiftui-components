import SwiftUI

/// AI 设置标杆规格重构视图（AI Settings Specimen）
///
/// 针对用户原稿中出现的“首行锯齿错位、Section 图标打架噪音、副标题硬断行与孤字、选择器折行溢出”等问题
/// 进行彻底系统化重构，展现符合 Apple HIG 与 Aura 极简克制美学的标杆级表单。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【对齐平整】：同一卡片内部 Row 保持严格的统一图标占位（32pt 列宽），彻底根除首字锯齿错位；
/// 2. 【去噪音骨架】：Section Header 移除彩色小方块底座，纯文字大标撑起黑白骨架，杜绝与卡片内部图标争夺焦点；
/// 3. 【精致排版】：右侧选择器采用“次级文本 + 优雅推荐微标 + 微型上下箭头”单行排版，杜绝生硬两行截断；
/// 4. 【严控孤字断行】：文案精炼，严禁出现“停 / 顿”词汇被劈开或单独孤字挂在第二行的丑陋排版；
/// 5. 【原生导航栏】：顶部采用标准 iOS Sheet 导航条与原生完成按钮，消除异物感浮动白药丸。
///
/// ```swift
/// AISettingsSpecimenView()
///     .themePalette(.indigo)
/// ```
public struct AISettingsSpecimenView: View {
    @Environment(\.themePalette) private var themePalette
    @State private var selectedProvider = "内置 AI"
    @State private var isTesting = false
    @State private var testLatency: Int? = 42

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            // 顶部标准 Sheet 导航栏
            sheetNavigationBar

            // 主滚动容器
            AuraScaffold {
                // Section 1: AI 服务商
                providerSection

                // Section 2: 创作者人设与技能
                personaAndSkillsSection

                // Section 3: 提词断句与节奏
                teleprompterPacingSection

                // Section 4: 全局宣发与爆款智库
                distributionSection
            }
        }
        .background(DesignSystem.Color.background.ignoresSafeArea())
    }

    // MARK: - 顶部原生 Sheet 导航条
    private var sheetNavigationBar: some View {
        VStack(spacing: 6) {
            // 顶部轻量抓手
            Capsule()
                .fill(Color.primary.opacity(0.18))
                .frame(width: 36, height: 5)
                .padding(.top, 6)

            ZStack {
                Text("AI 设置")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                HStack {
                    Spacer()

                    Button(action: {
                        HapticManager.impact(.light)
                    }) {
                        Text("完成")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(themePalette.color)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, DesignSystem.Layout.pagePadding)
                }
            }
            .frame(height: 38)
        }
        .background(DesignSystem.Color.background)
    }

    // MARK: - 01 AI 服务商
    private var providerSection: some View {
        AuraSection("AI 服务商") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    // 第 1 行：服务提供商
                    SettingsRow(
                        icon: "cpu.fill",
                        iconColor: themePalette.color,
                        title: "服务提供商"
                    ) {
                        HStack(spacing: 6) {
                            Text(selectedProvider)
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundColor(DesignSystem.Color.textSecondary)

                            PillBadge(verbatim: "推荐", style: .subtle(themePalette.color))

                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(DesignSystem.Color.textTertiary)
                        }
                    }

                    Divider().padding(.leading, 58)

                    // 第 2 行：连通性（规范对齐，带相同基准的图标）
                    SettingsRow(
                        icon: "antenna.radiowaves.left.and.right",
                        iconColor: themePalette.color,
                        title: "服务连通性",
                        verbatimSubtitle: testLatency != nil ? "链路通畅 · 响应延时 42ms" : "检测服务可用性与响应延迟"
                    ) {
                        Button(action: {
                            HapticManager.impact(.medium)
                            isTesting = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                isTesting = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                if isTesting {
                                    ProgressView()
                                        .scaleEffect(0.65)
                                        .frame(width: 12, height: 12)
                                } else {
                                    Image(systemName: "bolt.fill")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                Text("测试")
                                    .font(DesignSystem.Typography.caption)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 11)
                            .padding(.vertical, 5)
                            .background(themePalette.color.opacity(0.12))
                            .foregroundColor(themePalette.color)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - 02 创作者人设与技能
    private var personaAndSkillsSection: some View {
        AuraSection("创作者人设与技能") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "person.text.rectangle.fill",
                        iconColor: themePalette.color,
                        title: "创作者人设",
                        subtitle: "定位、语言调性与去 AI 味表达规则"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }

                    Divider().padding(.leading, 58)

                    SettingsRow(
                        icon: "sparkles",
                        iconColor: themePalette.color,
                        title: "AI 功能管理",
                        verbatimSubtitle: "3 项已启用"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }
                }
            }
        }
    }

    // MARK: - 03 提词断句与节奏
    private var teleprompterPacingSection: some View {
        AuraSection("提词断句与节奏") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                SettingsRow(
                    icon: "scissors",
                    iconColor: themePalette.color,
                    title: "断句与播报停顿",
                    subtitle: "紧凑短句与自然口播停顿规则"
                ) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
            }
        }
    }

    // MARK: - 04 全局宣发与爆款智库
    private var distributionSection: some View {
        AuraSection("全局宣发与爆款智库") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                SettingsRow(
                    icon: "megaphone.fill",
                    iconColor: themePalette.color,
                    title: "宣发文案与选题库",
                    subtitle: "多平台分发模板与爆款钩子库"
                ) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
            }
        }
    }
}

// MARK: - 原版还原对照视图（用于精确复现并标注文档缺陷）
public struct AIBuggyOriginalSpecimenView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            // 原版顶部：生硬贴片白药丸
            HStack {
                Spacer()
                Text("AI 设置")
                    .font(.system(size: 17, weight: .regular))
                    .padding(.leading, 56)
                Spacer()
                Text("完成")
                    .font(.system(size: 15, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            ScrollView {
                VStack(spacing: 24) {
                    // Section 1: Header 带图标，Row 1 有图标，Row 2 无图标（错位）
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            IconBadge(systemName: "globe", color: Color(red: 0.35, green: 0.50, blue: 0.72), size: 24)
                            Text("AI 服务商")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }

                        BaseCard(cornerRadius: 24, padding: 16) {
                            VStack(spacing: 14) {
                                // Row 1: 有图标，右侧溢出折行
                                HStack(spacing: 12) {
                                    IconBadge(systemName: "doc.text.fill", color: Color(red: 0.15, green: 0.50, blue: 0.95), size: 24)
                                    Text("服务商")
                                        .font(.system(size: 16))
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 1) {
                                        Text("内置 AI")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.blue)
                                        HStack(spacing: 2) {
                                            Text("(推荐)")
                                                .font(.system(size: 13))
                                                .foregroundColor(.blue)
                                            Image(systemName: "chevron.up.chevron.down")
                                                .font(.system(size: 11))
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }

                                Divider()

                                // Row 2: 无图标（致命首字错位！），淡蓝药丸
                                HStack {
                                    Text("连通性")
                                        .font(.system(size: 16))
                                    Spacer()
                                    Text("测试")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.blue)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.10))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    // Section 2: Header 带图标，副标题折行断裂
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            IconBadge(systemName: "person.crop.rectangle", color: Color(red: 0.35, green: 0.50, blue: 0.72), size: 24)
                            Text("创作者人设与 AI 技能")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }

                        BaseCard(cornerRadius: 24, padding: 16) {
                            VStack(spacing: 14) {
                                HStack(spacing: 12) {
                                    IconBadge(systemName: "person.text.rectangle.fill", color: Color.indigo, size: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("创作者人设")
                                            .font(.system(size: 16))
                                        Text("配置定位、语言调性与去 AI 味\n规则")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color.secondary.opacity(0.6))
                                }

                                Divider()

                                HStack(spacing: 12) {
                                    IconBadge(systemName: "sparkles", color: Color(red: 0.85, green: 0.20, blue: 0.85), size: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("AI 功能管理")
                                            .font(.system(size: 16))
                                        Text("3 项已启用")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color.secondary.opacity(0.6))
                                }
                            }
                        }
                    }

                    // Section 3: Header 带图标，中文被硬生生断词（停 / 顿）
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            IconBadge(systemName: "scissors", color: Color(red: 0.35, green: 0.50, blue: 0.72), size: 24)
                            Text("提词断句与节奏")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }

                        BaseCard(cornerRadius: 24, padding: 16) {
                            HStack(spacing: 12) {
                                IconBadge(systemName: "scissors", color: Color(red: 0.10, green: 0.70, blue: 0.75), size: 24)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("提词断句提示词")
                                        .font(.system(size: 16))
                                    Text("配置紧凑短句、自然口播、演讲停\n顿等节奏规则")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(Color.secondary.opacity(0.6))
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.969).ignoresSafeArea())
    }
}

#Preview("AISettings - Refined") {
    AISettingsSpecimenView()
        .themePalette(.indigo)
}

#Preview("AISettings - Before") {
    AIBuggyOriginalSpecimenView()
}
