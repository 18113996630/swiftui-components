import SwiftUI

/// 微光设计系统全景交互式预览展厅（AuraDesignSystem）
/// 可在 Xcode Previews 中直接交互测试调色盘换肤、时间线打卡、胶囊分段器、流式布局、Chip、滑杆与毛玻璃浮窗
public struct DesignSystemGalleryView: View {
    // 动态主题选择
    @State private var currentTheme: ThemePalette = .berry
    @State private var themeModeIndex = 0
    private let themeModes = ["完整", "浅色", "深色"]

    // 交互控件状态
    @State private var pillTapCount = 0
    @State private var isProActive = true
    @State private var isPushToggleOn = true

    // 清单项状态
    @State private var checkItem1 = true
    @State private var checkItem2 = false
    @State private var checkItem3 = false

    // 时间线任务状态
    @State private var task1Done = true
    @State private var task2Done = false
    @State private var task3Done = false

    // 新增组件交互状态
    @State private var selectedTab = "提词文稿"
    private let tabItems = ["提词文稿", "关联录像", "全域分发"]

    @State private var currentPaging = 1
    @State private var sliderFontSize = 28.0
    @State private var sliderSpeed = 160.0

    @State private var selectedChips: Set<String> = ["爆款短剧", "口播提词"]
    private let candidateChips = ["爆款短剧", "口播提词", "AI改写", "宣发海报", "灵感速记", "热点追踪"]

    @State private var deletableTags = ["个人成长", "创业复盘", "时间管理", "认知破局"]
    @State private var selectedSymbol = "sparkles"
    private let symbolList = ["sparkles", "bolt.fill", "flame.fill", "heart.fill", "star.fill", "video.fill", "mic.fill", "waveform"]

    @State private var customColor: Color = .purple
    private let colorList: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .blue, .indigo, .purple, .pink]

    @State private var inputKey = "sk-test-example-key"
    @State private var inputEndpoint = ""
    @State private var showToast = false
    @State private var dynamicToastMessage: LocalizedStringKey? = nil

    @State private var isStreamingGenerating = true
    @State private var streamingText = "正在基于 Aura 范式生成黄金 3 秒开场白：\n“90% 的创作者都做错了第一步，真正的高完播率其实藏在这三个细节里……”"

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Layout.sectionSpacing) {
                heroHeaderSection
                themePaletteSelectorSection
                heroBannerDemoSection
                timelineSection
                quickActionCardSection
                mediaThumbnailCardSection
                segmentedAndControlsSection
                flowLayoutAndChipsSection
                navigationAndPagingSection
                slidersAndPickersSection
                formAndInputsSection
                feedbackAndStreamingSection
                checklistSection
                tokensColorSection
                tokensTypographySection
                settingsRowSection
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
        .background(DesignSystem.Color.background.ignoresSafeArea())
        .themePalette(currentTheme)
        .toastHUD(isPresented: $showToast, message: "文稿已成功存入爆款智库", iconColor: currentTheme.color)
        .toastHUD(message: $dynamicToastMessage, icon: "bolt.badge.checkmark.fill", iconColor: currentTheme.color)
    }

    // MARK: - 01 顶部 Hero Header
    private var heroHeaderSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Text("Aura UI System")
                    .font(DesignSystem.Typography.largeTitle)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                Spacer()

                Text("iOS 18")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(currentTheme.tint)
                    .foregroundColor(currentTheme.color)
                    .clipShape(Capsule())
            }

            Text("ADA 获奖级质感：28pt 浮岛圆角、漫反射软阴影、饱满时间线与多巴胺活力主题")
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Color.textSecondary)

            // 当前主题对角微光渐变横幅
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.button, style: .continuous)
                .fill(currentTheme.gradient)
                .frame(height: 52)
                .overlay(
                    HStack {
                        Image(systemName: "sparkles")
                        Text("\(currentTheme.title) 主题高光渐变")
                            .font(DesignSystem.Typography.headline)
                        Spacer()
                        Text("实时变色")
                            .font(DesignSystem.Typography.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, DesignSystem.Layout.cardPadding)
                )
                .shadow(color: currentTheme.color.opacity(0.3), radius: 10, x: 0, y: 4)
                .padding(.top, DesignSystem.Spacing.tiny)
        }
    }

    // MARK: - 02 多巴胺活力主题色盘拾取器
    private var themePaletteSelectorSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("01 应用色彩主题 (9 色多巴胺活力色盘)")

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        Text("点击即时换肤体验")
                            .font(DesignSystem.Typography.headline)
                        Spacer()
                        Text(currentTheme.title)
                            .font(DesignSystem.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(currentTheme.color)
                    }

                    PaletteColorPicker(selectedPalette: $currentTheme)

                    Text("包含珊瑚粉、暖日橙、琥珀黄、抹茶绿、晴空蓝、翡翠青、浆果红、午夜蓝与极简黑。")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - 03 沉浸式 Hero Banner 模态顶栏
    private var heroBannerDemoSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("02 沉浸式彩色顶栏卡片 (HeroBannerSheet)")

            HeroBannerSheet(
                title: "按您的方式定制",
                subtitle: "打造个性化专属日程看板",
                stepText: "第 1/4 步",
                icon: "gearshape.fill",
                palette: currentTheme,
                onClose: {},
                onTrailingAction: {}
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    Text("浮岛卡片内容嵌入")
                        .font(DesignSystem.Typography.headline)
                    Text("采用 Aura 标志性彩色顶栏，包含磨砂关闭键、白色超椭圆图标徽章与步骤标题。")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                }
                .padding(DesignSystem.Layout.cardPadding)
            }
            .frame(height: 270)
            .shadow(
                color: DesignSystem.Shadow.ambient.color,
                radius: DesignSystem.Shadow.ambient.radius,
                x: DesignSystem.Shadow.ambient.x,
                y: DesignSystem.Shadow.ambient.y
            )
        }
    }

    // MARK: - 04 核心时间线流转
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("03 核心时间线轨道 (38pt 饱满节点 + 虚线空闲时段)")

            BaseCard {
                VStack(spacing: 0) {
                    TimelineTaskRow(
                        time: "09:00",
                        timeRange: "09:00 - 10:00 (1小时)",
                        title: "准备早晨会议",
                        subtitle: "梳理今日核心目标与架构对齐",
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
                        title: "进入您的日程表",
                        subtitle: "验证 28pt 浮岛卡片与虚线韵律线",
                        icon: "paintpalette.fill",
                        color: currentTheme.color,
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
            }
        }
    }

    // MARK: - 05 快捷入口卡片 (QuickActionCard & i18n Elasticity)
    private var quickActionCardSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("05 快捷入口卡片与多语言自适应 (QuickActionCard)")

            HStack(spacing: DesignSystem.Spacing.medium) {
                QuickActionCard(
                    icon: "lightbulb.fill",
                    iconColor: currentTheme.color,
                    title: "灵感写稿",
                    subtitle: "AI 智能生成"
                ) {
                    showToast = true
                }

                QuickActionCard(
                    icon: "photo.badge.plus.fill",
                    iconColor: .orange,
                    title: "相册选图",
                    subtitle: "提取截屏文案"
                ) {
                    showToast = true
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - 05.1 媒体与视频缩略图流 (MediaThumbnailCard)
    private var mediaThumbnailCardSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("05.1 媒体与视频缩略图流 (MediaThumbnailCard)")

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        Label("关联录制视频", systemImage: "video.badge.waveform")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Color.textPrimary)

                        Spacer()

                        PillBadge(verbatim: "2 条录像", style: .subtle(currentTheme.color))
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.medium) {
                            MediaThumbnailCard(
                                verbatimTitle: "提词完整录制 (主镜头)",
                                verbatimSubtitle: "今天 14:20 · 4K 60fps",
                                duration: "01:24",
                                verbatimBadge: "精选",
                                badgeColor: ThemePalette.coral.color
                            ) {
                                showToast = true
                            }

                            MediaThumbnailCard(
                                verbatimTitle: "中景近景重录",
                                verbatimSubtitle: "昨天 19:40 · 1080P",
                                duration: "00:48"
                            ) {
                                showToast = true
                            }

                            MediaThumbnailCard(
                                verbatimTitle: "小红书高清长图",
                                verbatimSubtitle: "已排版完成",
                                duration: "长图",
                                showPlayButton: false
                            ) {
                                LinearGradient(
                                    colors: [currentTheme.color.opacity(0.8), currentTheme.color.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .overlay(
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.9))
                                )
                            } action: {
                                showToast = true
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - 06 胶囊分段选择器与按压手感
    private var segmentedAndControlsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("06 软底胶囊分段器与按压手感 (PillSegmentedPicker)")

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("主题外观分段器（去金属反光、柔和滑块）")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        PillSegmentedPicker(
                            selection: $themeModeIndex,
                            items: [0, 1, 2],
                            activeColor: currentTheme.color,
                            titleForSelection: { themeModes[$0] }
                        )
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("胶囊按键与微缩放手感 (PillButton)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        HStack(spacing: DesignSystem.Spacing.small) {
                            PillButton(
                                title: "点击 +1 (\(pillTapCount))",
                                icon: "hand.tap.fill"
                            ) {
                                pillTapCount += 1
                            }

                            PillButton(title: "状态标签", icon: "sparkles", action: {})
                            PillButton(title: "纯文字", action: {})
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - 06 流式布局与微标/芯片 (FlowLayout, PillBadge, Chips)
    private var flowLayoutAndChipsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("05 流式折行布局与原子微标 (FlowLayout & Chips)")

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("纯展示型微标 (PillBadge)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        HStack(spacing: DesignSystem.Spacing.small) {
                            PillBadge(title: "高曝光爆款", icon: "flame.fill", style: .subtle(currentTheme.color))
                            PillBadge(title: "已归档", style: .neutral)
                            PillBadge(title: "VIP 专享", icon: "crown.fill", style: .solid(ThemePalette.coral.color))
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("状态多选芯片 (SelectableChip)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                            ForEach(candidateChips, id: \.self) { chip in
                                SelectableChip(
                                    verbatim: chip,
                                    isSelected: selectedChips.contains(chip)
                                ) {
                                    if selectedChips.contains(chip) {
                                        selectedChips.remove(chip)
                                    } else {
                                        selectedChips.insert(chip)
                                    }
                                }
                            }
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("可删除话题标签 (DeletableChip)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                            ForEach(deletableTags, id: \.self) { tag in
                                DeletableChip(verbatim: tag) {
                                    deletableTags.removeAll { $0 == tag }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - 07 极简下划线导航与弹性分页指示器
    private var navigationAndPagingSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("06 下划线 Tab 栏与弹性分页 (UnderlinedTabBar & Paging)")

            BaseCard {
                VStack(spacing: DesignSystem.Spacing.large) {
                    UnderlinedTabBar(
                        selection: $selectedTab,
                        tabs: tabItems,
                        activeColor: currentTheme.color,
                        titleForTab: { $0 }
                    )

                    HStack {
                        Text("当前聚焦视图: \(selectedTab)")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                        Spacer()
                        PagingIndicatorCapsule(
                            currentPage: $currentPaging,
                            totalPages: 4,
                            showFractionLabel: true,
                            activeColor: currentTheme.color
                        )
                    }
                    .padding(.top, DesignSystem.Spacing.small)
                }
            }
        }
    }

    // MARK: - 08 等宽微调滑杆与图标选择器
    private var slidersAndPickersSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("07 等宽微调滑杆与图标矩阵 (Sliders & Symbol Picker)")

            BaseCard {
                VStack(spacing: DesignSystem.Spacing.large) {
                    PrecisionSliderRow(
                        icon: "textformat.size",
                        title: "字幕字体尺寸",
                        subtitle: "精准等宽微胶囊数值指示",
                        value: $sliderFontSize,
                        range: 16...64,
                        step: 1.0,
                        unit: "pt",
                        tintColor: currentTheme.color
                    )

                    Divider()

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack {
                            Text("功能图标选取矩阵 (SFSymbolGridPicker)")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Color.textSecondary)
                            Spacer()
                            Image(systemName: selectedSymbol)
                                .foregroundColor(currentTheme.color)
                        }

                        SFSymbolGridPicker(
                            selectedSymbol: $selectedSymbol,
                            symbols: symbolList,
                            columns: 4,
                            tintColor: currentTheme.color
                        )
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("通用调色盘行 (ColorPickerRow)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textSecondary)

                        ColorPickerRow(selectedColor: $customColor, colors: colorList)
                    }
                }
            }
        }
    }

    // MARK: - 09 表单行、输入项与居中操作
    private var formAndInputsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("08 表单行与输入控件 (Form Rows & Inputs)")

            BaseCard(cornerRadius: DesignSystem.CornerRadius.card, padding: 16, showBorder: true) {
                VStack(spacing: DesignSystem.Spacing.medium) {
                    HIGSectionHeaderView(
                        title: "AI 服务参数",
                        icon: "network",
                        badgeText: "已联通"
                    ) {
                        Button("重置") {}
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(currentTheme.color)
                    }

                    ClearableTextFieldRow(
                        title: "接口路径",
                        placeholder: "https://api.openai.com/v1",
                        text: $inputEndpoint,
                        showPasteButton: true
                    )

                    Divider()

                    ClearableSecureFieldRow(
                        title: "密钥 Key",
                        placeholder: "填写以 sk- 开头的密钥",
                        text: $inputKey,
                        allowReveal: true,
                        showPasteButton: true
                    )

                    Divider()

                    FormRowActionButton(
                        title: "重新校验并测试连通性",
                        icon: "bolt.horizontal.fill",
                        role: .regular
                    ) {
                        dynamicToastMessage = "AI 服务连通性测试通过（可选值驱动）"
                    }
                }
            }
        }
    }

    // MARK: - 10 提示通栏、空状态与打字机卡片
    private var feedbackAndStreamingSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("09 状态通知、空状态与打字机 (Feedback & Streaming)")

            VStack(spacing: DesignSystem.Spacing.medium) {
                NoticeBanner(
                    style: .info,
                    message: "当前文案适配小红书平台格式，字数建议控制在 800 字以内",
                    actionTitle: "查看规范",
                    onAction: {}
                )

                NoticeBanner(
                    style: .warning,
                    message: "检测到违禁词：第 3 行包含敏感词汇，建议替换",
                    actionTitle: "一键替换",
                    onAction: {}
                )

                TypewriterStreamingCard(
                    title: "AI 实时排版生成流",
                    streamingText: streamingText,
                    isGenerating: isStreamingGenerating
                ) {
                    isStreamingGenerating = false
                }

                BaseCard {
                    EmptyStateView(
                        icon: "tray.fill",
                        title: "智库暂无收藏文稿",
                        description: "将优质的对标文案或生成结果加入智库，随时提取使用。"
                    ) {
                        PillButton(title: "导入示例素材", icon: "arrow.down.doc", action: {})
                    }
                }
            }
        }
    }

    // MARK: - 11 清单卡片
    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("10 任务清单项 (ChecklistRow)")

            BaseCard {
                VStack(spacing: 0) {
                    ChecklistRow(
                        title: "开启通知与提醒",
                        isChecked: $checkItem1,
                        activeColor: currentTheme.color,
                        onDelete: {}
                    )
                    Divider()
                    ChecklistRow(
                        title: "连接系统日历",
                        isChecked: $checkItem2,
                        activeColor: currentTheme.color,
                        onDelete: {}
                    )
                    Divider()
                    ChecklistRow(
                        title: "配置深浅色外观主题",
                        isChecked: $checkItem3,
                        activeColor: currentTheme.color,
                        onDelete: {}
                    )
                }
            }
        }
    }

    // MARK: - 12 色彩系统矩阵
    private var tokensColorSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("11 系统底色与层级 (Color Hierarchy)")

            BaseCard {
                VStack(spacing: DesignSystem.Spacing.medium) {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        colorSwatch(name: "Current Theme", color: currentTheme.color, isDarkText: false)
                        colorSwatch(name: "Theme Tint", color: currentTheme.tint, isDarkText: true)
                        colorSwatch(name: "Text 1st", color: DesignSystem.Color.textPrimary, isDarkText: false)
                        colorSwatch(name: "Text 2nd", color: DesignSystem.Color.textSecondary, isDarkText: false)
                    }

                    HStack(spacing: DesignSystem.Spacing.small) {
                        colorSwatch(name: "Card Bg", color: DesignSystem.Color.cardBackground, isDarkText: true, border: true)
                        colorSwatch(name: "Page Bg", color: DesignSystem.Color.background, isDarkText: true, border: true)
                        colorSwatch(name: "Tertiary", color: DesignSystem.Color.textTertiary, isDarkText: false)
                    }
                }
            }
        }
    }

    // MARK: - 13 SF Pro Rounded 全域排版字阶
    private var tokensTypographySection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("12 排版与字阶 (SF Pro Rounded)")

            BaseCard {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                    typeRow(label: "LargeTitle (28pt Rounded Bold)", font: DesignSystem.Typography.largeTitle, sample: "主页面与大看板标题")
                    Divider()
                    typeRow(label: "Title (20pt Rounded Bold)", font: DesignSystem.Typography.title, sample: "卡片与主要模块标题")
                    Divider()
                    typeRow(label: "Headline (17pt Rounded Semibold)", font: DesignSystem.Typography.headline, sample: "列表主任务与强导向文本")
                    Divider()
                    typeRow(label: "Body (15pt Rounded Regular)", font: DesignSystem.Typography.body, sample: "副标题与自然说明信息")
                    Divider()
                    typeRow(label: "Time (13pt Rounded Medium)", font: DesignSystem.Typography.time, sample: "09:41:00 • 2026-09-22")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - 14 设置列表行
    private var settingsRowSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            sectionTitle("13 设置行入口 (SettingsRow)")

            VStack(spacing: 0) {
                SettingsRow(
                    icon: "bell.badge.fill",
                    iconColor: ThemePalette.coral.color,
                    title: "消息推送通知",
                    subtitle: "每日早晨自动推送提词计划"
                )

                Divider().padding(.leading, 56)

                SettingsRow.toggle(
                    icon: "sparkles",
                    iconColor: currentTheme.color,
                    title: "AI 实时润色辅助",
                    verbatimSubtitle: isPushToggleOn ? "2 项智能辅助规则生效中" : "未开启",
                    isOn: $isPushToggleOn
                )

                Divider().padding(.leading, 56)

                SettingsRow(
                    icon: "server.rack",
                    iconColor: ThemePalette.teal.color,
                    title: "本地智能缓存",
                    verbatimSubtitle: "已占用 128.4 MB (32 项)"
                )

                Divider().padding(.leading, 56)

                SettingsRow(
                    icon: "lock.shield.fill",
                    iconColor: ThemePalette.indigo.color,
                    title: "高级会员与云端同步",
                    badgeText: isProActive ? "PRO" : nil
                ) {
                    isProActive.toggle()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.card, style: .continuous))
            .shadow(
                color: DesignSystem.Shadow.ambient.color,
                radius: DesignSystem.Shadow.ambient.radius,
                x: DesignSystem.Shadow.ambient.x,
                y: DesignSystem.Shadow.ambient.y
            )
        }
    }

    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(DesignSystem.Typography.headline)
            .foregroundColor(DesignSystem.Color.textPrimary)
            .padding(.leading, DesignSystem.Spacing.tiny)
    }

    private func colorSwatch(name: String, color: Color, isDarkText: Bool, border: Bool = false) -> some View {
        VStack(spacing: DesignSystem.Spacing.tiny) {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small, style: .continuous)
                .fill(color)
                .frame(height: 38)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small, style: .continuous)
                        .stroke(border ? Color.gray.opacity(0.25) : Color.clear, lineWidth: 1)
                )

            Text(name)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(DesignSystem.Color.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private func typeRow(label: String, font: Font, sample: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(DesignSystem.Color.textTertiary)

            Text(sample)
                .font(font)
                .foregroundColor(DesignSystem.Color.textPrimary)
        }
    }
}

// MARK: - Previews
#Preview("Gallery - Light Mode") {
    DesignSystemGalleryView()
}

#Preview("Gallery - Dark Mode") {
    DesignSystemGalleryView()
        .preferredColorScheme(.dark)
}
