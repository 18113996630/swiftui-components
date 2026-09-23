import SwiftUI

/// 极简纯文字下划线导航 Tab 栏（Aura 标杆风格）
///
/// 区别于大胶囊分段器，更适合主页面或模态弹窗顶部的一级内容视域切换。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：Tab 栏选项文案纯由调用方通过闭包提供；
/// 2. 【下划线微动效】：指示器为 22x3pt 胶囊，切换时严格依赖 `.matchedGeometryEffect` 与轻触刻度手感；
/// 3. 【无二次透明稀释】：选中态文字为 `textPrimary`，未选中态为 `textTertiary`，黑白骨架清晰；
/// 4. 【字阶收敛】：Tab 选项采用 `DesignSystem.Typography.callout` (15pt)，顶栏排版紧凑不拥挤。
///
/// ```swift
/// // 1. 本地化映射（Xcode 自动提取）
/// UnderlinedTabBar(
///     selection: $selectedTab,
///     tabs: TabItem.allCases,
///     titleKeyForTab: { $0.localizationKey }
/// )
///
/// // 2. 动态非本地化直出
/// UnderlinedTabBar(
///     selection: $selectedTab,
///     tabs: dynamicTabs,
///     titleForTab: { $0.title }
/// )
/// ```
public struct UnderlinedTabBar<T: Hashable>: View {
    @Environment(\.themePalette) private var themePalette
    @Binding private var selection: T
    private let tabs: [T]
    private let textForTab: (T) -> LocalizedText
    private let customActiveColor: Color?
    private let spacing: CGFloat
    @Namespace private var underlineNamespace

    /// 本地化初始化器（支持 String Catalog 自动抓取）
    public init(
        selection: Binding<T>,
        tabs: [T],
        activeColor: Color? = nil,
        spacing: CGFloat = 28,
        titleKeyForTab: @escaping (T) -> LocalizedStringKey
    ) {
        self._selection = selection
        self.tabs = tabs
        self.customActiveColor = activeColor
        self.spacing = spacing
        self.textForTab = { .localized(titleKeyForTab($0)) }
    }

    /// 动态非本地化直出初始化器
    public init(
        selection: Binding<T>,
        tabs: [T],
        activeColor: Color? = nil,
        spacing: CGFloat = 28,
        titleForTab: @escaping (T) -> String
    ) {
        self._selection = selection
        self.tabs = tabs
        self.customActiveColor = activeColor
        self.spacing = spacing
        self.textForTab = { .verbatim(titleForTab($0)) }
    }

    private var effectiveActiveColor: Color {
        customActiveColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(tabs, id: \.self) { tab in
                let isSelected = selection == tab

                Button(action: {
                    guard selection != tab else { return }
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                        selection = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        textForTab(tab).makeText()
                            .font(DesignSystem.Typography.callout)
                            .fontWeight(isSelected ? .bold : .medium)
                            .foregroundColor(isSelected ? DesignSystem.Color.textPrimary : DesignSystem.Color.textTertiary)

                        // 底部平滑下划线胶囊指示器
                        ZStack {
                            if isSelected {
                                Capsule()
                                    .fill(effectiveActiveColor)
                                    .frame(width: 22, height: 3)
                                    .matchedGeometryEffect(id: "UnderlineIndicator", in: underlineNamespace)
                                    .shadow(color: effectiveActiveColor.opacity(0.35), radius: 4, x: 0, y: 2)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(width: 22, height: 3)
                            }
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, DesignSystem.Layout.pagePadding)
        .padding(.top, DesignSystem.Spacing.small)
    }
}

#Preview("UnderlinedTabBar Preview") {
    UnderlinedTabBarPreviewHelper()
}

private struct UnderlinedTabBarPreviewHelper: View {
    enum TabItem: String, CaseIterable {
        case scripts = "提词文稿"
        case recordings = "关联录像"
        case distribution = "全域分发"
    }

    @State private var currentTab: TabItem = .scripts

    var body: some View {
        ZStack {
            DesignSystem.Color.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Spacing.large) {
                UnderlinedTabBar(
                    selection: $currentTab,
                    tabs: TabItem.allCases,
                    titleForTab: { $0.rawValue }
                )

                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("当前内容区域: \(currentTab.rawValue)")
                            .font(DesignSystem.Typography.headline)
                        Text("平滑下划线动画严格对齐 22x3pt 胶囊与轻触刻度手感。")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, DesignSystem.Layout.pagePadding)

                Spacer()
            }
        }
        .themePalette(.berry)
    }
}
