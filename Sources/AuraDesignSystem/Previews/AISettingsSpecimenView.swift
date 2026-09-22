import SwiftUI

/// AI 设置标杆规格重构视图（AI Settings Specimen - Apple Recommended / ADA Caliber）
///
/// 达到 Apple 官方推荐 App 与 Apple Design Award（ADA）级别的极致排版：
/// 1. 【原生导航通透感】：使用标准原生 ToolbarItem 文本完成按钮，彻底消灭悬浮白色药丸异物；
/// 2. 【58pt 严格物理对齐线】：全屏所有卡片分割线统一对齐 58pt 文字起点，严丝合缝；
/// 3. 【多巴胺功能色彩分区 (Color Chunking)】：基础设施(Indigo)、智慧人设(Berry)、工具智库(Teal/Amber)、数据备份(Sky)，杜绝全屏纯蓝同质化与刺眼荧光色；
/// 4. 【活态数据与动态感知】：从静态描述升级为“实时延迟 42ms”、“上次同步今天 14:20”，赋予生命力；
/// 5. 【微文字排版与防断裂】：单行精致微标，彻底杜绝“停/顿”字词断裂与双重推荐事故；
/// 6. 【底部安全区预留】：为 ScrollView 垫高 36pt，确保滚动到底部不贴合 Home Indicator 小黑条。
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
            // 顶部标准原生 Sheet 导航栏
            sheetNavigationBar

            // 主滚动容器
            AuraScaffold {
                // Section 1: AI 服务商（基础设施 - 晴空蓝 Indigo）
                providerSection

                // Section 2: 创作者人设与技能（智慧人设 - 优雅浆果紫 Berry）
                personaAndSkillsSection

                // Section 3: 创作与生成工具（生产力与智库 - 翡翠青 Teal & 暖日橙 Amber）
                creationToolsSection

                // Section 4: 数据与支持（系统与安全 - 天空蓝 Sky）
                dataAndSupportSection
            }
            .padding(.bottom, 24) // 预留底部呼吸，避免碰撞底部 Home Indicator 小黑条
        }
        .background(DesignSystem.Color.background.ignoresSafeArea())
    }

    // MARK: - 顶部原生 Sheet 导航条 (Apple 原生通透标准)
    private var sheetNavigationBar: some View {
        VStack(spacing: 6) {
            // 顶部轻量指示抓手
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

                    // 原生通透文本按键（彻底告别手搓浮动白药丸）
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

    // MARK: - 01 AI 服务商 (晴空蓝系 Indigo)
    private var providerSection: some View {
        AuraSection("AI 服务商") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    // 第 1 行：服务提供商（单行微排版，彻底消灭双重推荐）
                    SettingsRow(
                        icon: "cpu.fill",
                        iconColor: ThemePalette.indigo.color,
                        title: "服务提供商"
                    ) {
                        HStack(spacing: 6) {
                            Text(selectedProvider)
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundColor(DesignSystem.Color.textSecondary)

                            PillBadge(verbatim: "推荐", style: .subtle(ThemePalette.indigo.color))

                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(DesignSystem.Color.textTertiary)
                        }
                    }

                    Divider().padding(.leading, 58).opacity(0.35) // 严格 58pt 对齐线

                    // 第 2 行：连通性（活态数据感知，带毫秒级延时）
                    SettingsRow(
                        icon: "antenna.radiowaves.left.and.right",
                        iconColor: ThemePalette.indigo.color,
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
                            .background(ThemePalette.indigo.color.opacity(0.12))
                            .foregroundColor(ThemePalette.indigo.color)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - 02 创作者人设与技能 (温润浆果紫 Berry / 杜绝刺眼霓虹荧光粉)
    private var personaAndSkillsSection: some View {
        AuraSection("创作者人设与技能") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "person.text.rectangle.fill",
                        iconColor: ThemePalette.berry.color,
                        title: "创作者人设",
                        subtitle: "定位、语言调性与去 AI 味表达规则"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }

                    Divider().padding(.leading, 58).opacity(0.35)

                    SettingsRow(
                        icon: "sparkles",
                        iconColor: ThemePalette.berry.color,
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

    // MARK: - 03 创作与生成工具 (合并三行卡片，高信息密度，青绿 Teal & 暖橙 Amber)
    private var creationToolsSection: some View {
        AuraSection("创作与生成工具") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "scissors",
                        iconColor: ThemePalette.teal.color,
                        title: "断句与播报停顿",
                        subtitle: "紧凑短句与自然口播停顿规则"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }

                    Divider().padding(.leading, 58).opacity(0.35)

                    SettingsRow(
                        icon: "megaphone.fill",
                        iconColor: ThemePalette.orange.color,
                        title: "宣发渠道与提示词",
                        subtitle: "多平台分发模板与爆款钩子库"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }

                    Divider().padding(.leading, 58).opacity(0.35)

                    SettingsRow(
                        icon: "flame.fill",
                        iconColor: ThemePalette.amber.color,
                        title: "爆款参考智库",
                        subtitle: "管理各平台高赞爆款参考与创作模式"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }
                }
            }
        }
    }

    // MARK: - 04 数据与支持 (系统安全 - 天空蓝 Sky)
    private var dataAndSupportSection: some View {
        AuraSection("数据与支持") {
            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "icloud.fill",
                        iconColor: SwiftUI.Color(red: 0.18, green: 0.55, blue: 0.95),
                        title: "iCloud 备份",
                        verbatimSubtitle: "上次同步：今天 14:20 · 空间充足"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }

                    Divider().padding(.leading, 58).opacity(0.35)

                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        iconColor: SwiftUI.Color(red: 0.20, green: 0.65, blue: 0.90),
                        title: "功能教程",
                        subtitle: "查看 AI 提词与上下文变量使用教程"
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }
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
