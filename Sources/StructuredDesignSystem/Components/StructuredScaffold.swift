import SwiftUI

/// Structured 标杆风格全屏页面脚手架容器
///
/// 统一管理全局背景底色（.systemGroupedBackground / ignoresSafeArea）、
/// 页面外边距（16pt pagePadding）、标准段落纵向律动（24pt sectionSpacing）
/// 以及动态主题色盘（ThemePalette）环境穿透。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【页面统一律动】：页面级业务视图必须首选 `StructuredScaffold` 作为根容器，禁止自由拼接杂乱外边距；
/// 2. 【段落呼吸间隔】：容器内部各 Section 之间强制保持 `DesignSystem.Layout.sectionSpacing` (24pt) 呼吸节奏，禁止堆叠过于密集的卡片；
/// 3. 【底板语义色】：背景自动应用 `DesignSystem.Color.background` 并安全区打底，业务层严禁自行覆盖纯白全屏背景破坏浮岛层次。
///
/// ```swift
/// StructuredScaffold {
///     StructuredSection(title: "个人看板", icon: "person.crop.circle") {
///         BaseCard {
///             Text("卡片内容").font(DesignSystem.Typography.headline)
///         }
///     }
/// }
/// ```
public struct StructuredScaffold<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Layout.sectionSpacing) {
                content
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
        .background(DesignSystem.Color.background.ignoresSafeArea())
    }
}

#Preview("StructuredScaffold Demo") {
    StructuredScaffold {
        StructuredSection(title: "核心参数", icon: "slider.horizontal.3", badgeText: "已保存") {
            BaseCard {
                Text("浮岛卡片内容 1")
                    .font(DesignSystem.Typography.headline)
            }
        }

        StructuredSection(title: "分发渠道", icon: "arrow.triangle.branch") {
            BaseCard {
                Text("浮岛卡片内容 2")
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Color.textSecondary)
            }
        }
    }
    .themePalette(.teal)
}
