import SwiftUI

/// 文稿首页多语言测试枚举
public enum DocumentHomeLanguage: String, CaseIterable, Sendable {
    case chinese = "中文"
    case english = "English"
    case german = "Deutsch (长文案压力测试)"
}

/// 文稿首页标杆重构规格视图（Document Home Specimen - Apple Recommended / iOS 26 Caliber）
///
/// 针对提词器/文稿管理首页进行极致排版重构，完美兼容 iOS 26 原生悬浮导航与底栏特性：
/// 1. 【原生顶底导航适配】：精确保留 iOS 26 原生圆形 Toolbar 按键与底部浮岛 Capsule TabBar，纠正未选中态层级失衡；
/// 2. 【多语言长文案自适应】：副标题支持弹性折行与自适应缩放（minimumScaleFactor 0.82），配合卡片统一等高（fixedSize + infinity），彻底解决德语/英语等长文案高低不平、折行截断问题；
/// 3. 【底部元数据秩序化】：统一“~1分33秒”与“391字”为规范微标，时间信息右沉淀，消除三种样式杂糅的拼凑感；
/// 4. 【WCAG 对比度与质感】：纯白浮岛卡片保护正文，细边框微光勾勒边缘，黑白骨架清晰通透。
///
/// ```swift
/// DocumentHomeSpecimenView(language: .chinese)
///     .themePalette(.indigo)
/// ```
public struct DocumentHomeSpecimenView: View {
    @Environment(\.themePalette) private var themePalette
    public let language: DocumentHomeLanguage
    @State private var searchText = ""
    @State private var selectedTab = 0 // 0: 文稿, 1: 视频

    public init(language: DocumentHomeLanguage = .chinese) {
        self.language = language
    }

    // MARK: - 多语言文案字典
    private var pageTitle: String {
        switch language {
        case .chinese: return "文稿"
        case .english: return "Scripts"
        case .german: return "Skripte"
        }
    }

    private var searchPrompt: String {
        switch language {
        case .chinese: return "搜索文稿"
        case .english: return "Search scripts"
        case .german: return "Skripte durchsuchen"
        }
    }

    private var action1Title: String {
        switch language {
        case .chinese: return "灵感写稿"
        case .english: return "AI Scripting"
        case .german: return "Inspiration"
        }
    }

    private var action1Subtitle: String {
        switch language {
        case .chinese: return "AI 智能生成"
        case .english: return "Generate talking drafts"
        case .german: return "KI-gestützte Skripte"
        }
    }

    private var action2Title: String {
        switch language {
        case .chinese: return "相册选图"
        case .english: return "From Photos"
        case .german: return "Fotomediathek"
        }
    }

    private var action2Subtitle: String {
        switch language {
        case .chinese: return "提取截屏文案"
        case .english: return "Extract screenshot text"
        case .german: return "Texte aus Screenshots"
        }
    }

    private var sectionTitle: String {
        switch language {
        case .chinese: return "我的文稿"
        case .english: return "My Scripts"
        case .german: return "Meine Skripte"
        }
    }

    private var sectionBadge: String {
        switch language {
        case .chinese: return "1 篇"
        case .english: return "1 script"
        case .german: return "1 Skript"
        }
    }

    private var docTitle: String {
        switch language {
        case .chinese: return "FloatText 测试文稿"
        case .english: return "FloatText Test Script"
        case .german: return "FloatText Testskript"
        }
    }

    private var docExcerpt: String {
        switch language {
        case .chinese:
            return "今天这段测试文案会覆盖大多数提词场景。你可以直接拿它验证新增、编辑、分句、预览、提词和画中..."
        case .english:
            return "This test script covers most teleprompter scenarios. You can verify adding, editing, sentence splitting, previewing..."
        case .german:
            return "Dieses Testskript deckt die meisten Teleprompter-Szenarien ab. Sie können Bearbeiten, Segmentierung und Vorschau testen..."
        }
    }

    private var docDuration: String {
        switch language {
        case .chinese: return "~1分33秒"
        case .english: return "~1m 33s"
        case .german: return "~1 Min 33 Sek"
        }
    }

    private var docWords: String {
        switch language {
        case .chinese: return "391字"
        case .english: return "391 words"
        case .german: return "391 Wörter"
        }
    }

    private var docDate: String {
        switch language {
        case .chinese: return "2天前"
        case .english: return "2d ago"
        case .german: return "Vor 2 Tagen"
        }
    }

    private var tab1Title: String {
        switch language {
        case .chinese: return "文稿"
        case .english: return "Scripts"
        case .german: return "Skripte"
        }
    }

    private var tab2Title: String {
        switch language {
        case .chinese: return "视频"
        case .english: return "Videos"
        case .german: return "Videos"
        }
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // 主滚动内容区
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                    // 1. iOS 26 原生风格顶部操作栏 (圆钮通透微光)
                    topNavigationBar

                    // 2. 页面大标题
                    Text(pageTitle)
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Color.textPrimary)
                        .padding(.horizontal, DesignSystem.Layout.pagePadding)

                    // 3. 搜索框 (修复 macOS 下 textField 边框并支持原生平滑样式)
                    searchBar
                        .padding(.horizontal, DesignSystem.Layout.pagePadding)

                    // 4. 快捷入口双列卡片 (多语言等高自适应)
                    quickActionSection
                        .padding(.horizontal, DesignSystem.Layout.pagePadding)

                    // 5. 我的文稿段落 (标准 AuraSection)
                    myDocumentsSection
                        .padding(.horizontal, DesignSystem.Layout.pagePadding)

                    // 底部为浮岛 TabBar 留出充足安全区 (避免内容遮挡)
                    Spacer(minLength: 88)
                }
                .padding(.top, 8)
            }
            .background(DesignSystem.Color.background.ignoresSafeArea())

            // 6. iOS 26 原生风格底部悬浮胶囊 TabBar
            floatingBottomTabBar
                .padding(.bottom, 10)
        }
        .themePalette(.indigo)
    }

    // MARK: - 1. 顶部操作栏 (iOS 26 原生圆钮风格)
    private var topNavigationBar: some View {
        HStack {
            // 设置按钮 (iOS 26 原生圆钮)
            Button(action: {
                HapticManager.impact(.light)
            }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(DesignSystem.Color.textPrimary)
                    .frame(width: 42, height: 42)
                    .background(DesignSystem.Color.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
                    )
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
            }
            .buttonStyle(.scale)

            Spacer()

            // 新建按钮 (iOS 26 原生圆钮，主题色强调)
            Button(action: {
                HapticManager.impact(.light)
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(themePalette.color)
                    .frame(width: 42, height: 42)
                    .background(DesignSystem.Color.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
                    )
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
            }
            .buttonStyle(.scale)
        }
        .padding(.horizontal, DesignSystem.Layout.pagePadding)
    }

    // MARK: - 3. 搜索栏
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(DesignSystem.Color.textTertiary)

            TextField(searchPrompt, text: $searchText)
                .textFieldStyle(.plain)
                .font(DesignSystem.Typography.calloutRegular)
                .foregroundColor(DesignSystem.Color.textPrimary)

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.Color.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - 4. 快捷入口区 (Quick Actions - 弹性等高)
    private var quickActionSection: some View {
        HStack(spacing: 12) {
            QuickActionCard(
                verbatim: action1Title,
                subtitle: action1Subtitle,
                icon: "lightbulb.fill",
                iconColor: Color(red: 0.28, green: 0.50, blue: 0.88)
            ) {
                HapticManager.impact(.light)
            }

            QuickActionCard(
                verbatim: action2Title,
                subtitle: action2Subtitle,
                icon: "photo.badge.plus.fill",
                iconColor: Color(red: 0.96, green: 0.56, blue: 0.22)
            ) {
                HapticManager.impact(.light)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - 5. 我的文稿段落
    private var myDocumentsSection: some View {
        AuraSection(
            verbatim: sectionTitle,
            badgeText: sectionBadge
        ) {
            BaseCard(
                cornerRadius: DesignSystem.CornerRadius.card,
                padding: 16,
                showBorder: true
            ) {
                VStack(alignment: .leading, spacing: 12) {
                    // 标题与更多操作
                    HStack {
                        Text(docTitle)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Color.textPrimary)

                        Spacer()

                        Button(action: {
                            HapticManager.impact(.light)
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(DesignSystem.Color.textSecondary)
                                .frame(width: 32, height: 32)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.scale)
                    }

                    // 摘要正文：保持自然行距与呼吸感
                    Text(docExcerpt)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                        .lineSpacing(3.5)
                        .lineLimit(2)

                    // 底部规整元数据行：规范微标 + 时间沉淀
                    HStack(spacing: DesignSystem.Spacing.small) {
                        PillBadge(verbatim: docDuration, icon: "clock", style: .subtle(themePalette.color))
                        PillBadge(verbatim: docWords, style: .neutral)

                        Spacer()

                        Text(docDate)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Color.textTertiary)
                    }
                }
            }
        }
    }

    // MARK: - 6. iOS 26 原生风格悬浮胶囊 TabBar
    private var floatingBottomTabBar: some View {
        HStack(spacing: 8) {
            // 文稿 Tab (选中态)
            tabItem(
                index: 0,
                title: tab1Title,
                icon: "doc.text.fill",
                isSelected: selectedTab == 0
            )

            // 视频 Tab (未选中态：次级灰，不抢戏)
            tabItem(
                index: 1,
                title: tab2Title,
                icon: "video.fill",
                isSelected: selectedTab == 1
            )
        }
        .padding(5)
        .background(
            Capsule()
                .fill(DesignSystem.Color.cardBackground)
        )
        .overlay(
            Capsule()
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 20,
            x: 0,
            y: 8
        )
    }

    private func tabItem(index: Int, title: String, icon: String, isSelected: Bool) -> some View {
        Button(action: {
            withAnimation(DesignSystem.Motion.springAnimation) {
                selectedTab = index
            }
            HapticManager.selection()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))

                Text(title)
                    .font(DesignSystem.Typography.footnote)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .foregroundColor(
                isSelected ? themePalette.color : DesignSystem.Color.textSecondary
            )
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(Color.primary.opacity(0.05))
                    } else {
                        Color.clear
                    }
                }
            )
        }
        .buttonStyle(.scale)
    }
}

/// 还原用户原版带瑕疵的页面（用于对比展示）
public struct DocumentHomeOriginalBuggyView: View {
    @State private var searchText = ""

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 原版顶栏
                    HStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "gearshape"))
                            .shadow(color: .black.opacity(0.05), radius: 4)

                        Spacer()

                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "plus").foregroundColor(.blue))
                            .shadow(color: .black.opacity(0.05), radius: 4)
                    }
                    .padding(.horizontal, 16)

                    Text("文稿")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 16)

                    // 原版搜索框
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("搜索文稿").foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Capsule())
                    .padding(.horizontal, 16)

                    // 原版快捷入口（单字孤行 + 挤压）
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                                .overlay(Image(systemName: "lightbulb.fill").foregroundColor(.white))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("灵感写稿").font(.system(size: 15, weight: .bold))
                                Text("AI 直出口播母\n稿") // 原版恶性单字孤行！
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(16)

                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .overlay(Image(systemName: "photo.badge.plus").foregroundColor(.white))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("相册选图").font(.system(size: 15, weight: .bold))
                                Text("智能提取截屏\n文案") // 原版双字词生硬折行！
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)

                    // 原版段落
                    HStack {
                        Text("我的文稿").font(.system(size: 17, weight: .bold))
                        Text("1 篇")
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 16)

                    // 原版文稿卡片（三套元数据杂糅）
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("FloatText 测试文稿").font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "ellipsis").foregroundColor(.gray)
                        }

                        Text("今天这段测试文案会覆盖大多数提词场景。你可以直接拿它验证新增、编辑、分句、预览、提词和画中...")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)

                        // 杂糅元数据：蓝胶囊 + 灰胶囊 + 裸露文本
                        HStack(spacing: 8) {
                            Text("~1分33秒")
                                .font(.system(size: 11))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Capsule())

                            Text("391字")
                                .font(.system(size: 11))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.gray.opacity(0.15))
                                .foregroundColor(.gray)
                                .clipShape(Capsule())

                            Text("2天前")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.98))

            // 原版底栏（未选中态为刺眼纯黑色 #000000）
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text.fill").foregroundColor(.blue)
                    Text("文稿").font(.system(size: 12, weight: .bold)).foregroundColor(.blue)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.15))
                .clipShape(Capsule())

                HStack(spacing: 6) {
                    Image(systemName: "video.fill").foregroundColor(.black) // 浓黑抢戏！
                    Text("视频").font(.system(size: 12, weight: .bold)).foregroundColor(.black)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }
            .padding(6)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.08), radius: 8)
            .padding(.bottom, 10)
        }
    }
}
