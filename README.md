# swiftui-components (AuraDesignSystem)

一个面向 iOS 18+ 的 SwiftUI 微光设计系统（AuraDesignSystem），以 ADA 获奖级视觉基调为准则，提供统一的设计令牌、原子微标、交互选择器、流式排版与浮岛卡片容器，便于多个独立应用保持高度视觉一致性与细腻交互手感。

## 设计系统核心规范 (Design DNA)

1. **全域 SF Pro Rounded 排版与 WCAG 4.5:1 对比度基准**：温暖、圆润且高辨识度，涵盖 `largeTitle` (28pt)、`title` (20pt)、`headline` (17pt Semibold 骨架)、`body` (16pt Regular)、`subheadline` (14pt Medium)、`caption` 与 `time` (13pt Semibold)，严禁二次透明度稀释，告别发灰发虚。
2. **连续曲率超椭圆 (Continuous Curvature)**：全系采用 `.continuous`，梯度覆盖 8pt (微标) / 14pt (按钮) / 20pt (卡片) / 28pt (浮岛主画布)。
3. **9 色多巴胺活力主题色盘**：`ThemePalette` 贯穿，通过 `@Environment(\.themePalette)` 全局穿透与即时换肤。
4. **漫反射环境光阴影与细微边缘**：统一 `24pt / 32pt` 柔和扩散阴影（Aura Ambient Shadow）与 `0.5pt hairlineBorder` 边缘高光。
5. **物理弹性缩放与细腻触觉**：统一 `ScaleButtonStyle` (0.97 按压缩放) 与集中式 `HapticManager` 机械震动反馈。
6. **全域国际化与零内置文案 (Zero Built-in Copy & String Catalog 自动抓取)**：组件库内所有展示文本组件全面支持 `LocalizedStringKey`，由 Xcode 15+ 编译期 AST 全自动提取至 `.xcstrings`；并提供 `verbatim:` 动态直出通道。组件内部坚持 100% 零内置文案，状态优先采用纯图标与微动效表达，实现完全通用的组件库架构。

## 目录结构

```text
docs/
└── AI_INTEGRATION_GUIDE.md        # AI 助手在外部业务工程接入本组件库的完整工作流与防翻车指南

Sources/AuraDesignSystem/
├── DesignSystem.swift              # 主题调色盘、颜色、字体、间距、圆角、漫反射阴影令牌
├── Localization/
│   └── LocalizedText.swift         # 统一国际化双通道文本底座 (LocalizedStringKey 抓取 & verbatim 直出)
├── Theme/
│   └── ThemeEnvironment.swift      # @Environment(\.themePalette) 全局动态主题穿透
├── Extensions/
│   └── View+DesignSystem.swift     # .auraCard() / .fadeEdge() / .ambientShadow() / .hairlineBorder()
├── Styles/
│   ├── ScaleButtonStyle.swift     # 弹性物理微缩触感样式 (.scale)
│   └── HapticManager.swift         # 集中式触觉震动管理器 (Impact / Notification / Selection)
├── Components/
│   ├── BaseCard.swift              # 浮岛卡片容器 (支持 20/28pt、内边距与细边框)
│   ├── FlowLayout.swift            # 原生流式折行布局协议 (iOS 16+)
│   ├── IconBadge.swift             # 彩色超椭圆图标徽章底座 (白底 SF Symbol 强化对比度)
│   ├── PillBadge.swift             # 纯展示型语义彩色微标 (.subtle / .solid / .neutral)
│   ├── PillButton.swift            # 胶囊微交互标签按键
│   ├── SelectableChip.swift        # 状态多选/单选胶囊芯片 (带 Checkmark 动画)
│   ├── DeletableChip.swift         # 可删除标签胶囊 (#话题标签与禁用词)
│   ├── PillSegmentedPicker.swift   # 软底胶囊分段选择器 (支持本地化与动态映射)
│   ├── UnderlinedTabBar.swift      # 极简纯文字下划线导航 Tab 栏 (支持本地化与动态映射)
│   ├── PagingIndicatorCapsule.swift # 物理弹性伸缩胶囊分页指示器 (支持数字胶囊)
│   ├── PrecisionSliderRow.swift    # 等宽数值微调滑杆行 (带 .monospacedDigit 微标)
│   ├── SFSymbolGridPicker.swift    # SF Symbol 图标矩阵选择器
│   ├── PaletteColorPicker.swift    # ConcentricColorCircle / ColorPickerRow / 9色主题拾取
│   ├── HIGSectionHeaderView.swift  # 表单与分组标准头部视图 (带图标底座与微标)
│   ├── SettingsRow.swift           # 标准表单行 (支持泛型 trailing、Toggle、通用 badgeText)
│   ├── ClearableTextFieldRow.swift # 卡片式带清空与快捷粘贴输入行
│   ├── FormRowActionButton.swift  # 表单居中功能与危险操作按钮
│   ├── KeyboardAccessoryBar.swift  # 键盘快捷辅助工具栏 (通用计数与收起键盘)
│   ├── ToastHUD.swift              # 毛玻璃悬浮轻提示与 .toastHUD(...) 修饰符
│   ├── NoticeBanner.swift          # 信息/警示/错误通栏提示卡片
│   ├── AuraScaffold.swift          # 标杆级全屏页面脚手架 (自动管理 16pt 外边距与 24pt 段落流)
│   ├── AuraSection.swift           # 标杆级段落分组容器 (集成 HIG 标头与 12pt 内边距)
│   ├── EmptyStateView.swift        # 标杆级居中空状态视图
│   ├── TypewriterStreamingCard.swift # 打字机流式生成与呼吸光标卡片 (纯图标状态与零内置文案)
│   ├── TimelineTaskRow.swift       # 38pt 饱满时间线节点与虚线空闲时段
│   ├── ChecklistRow.swift          # 子任务与待办清单行
│   └── HeroBannerSheet.swift       # 沉浸式彩色顶栏模态卡片
└── Previews/
    ├── DesignSystemGalleryView.swift # 全景交互式组件展厅 (包含全量组件与即时换肤)
    ├── TypographyShowcaseView.swift   # 排版字阶与 WCAG 4.5:1 对比度规范专项展示
    └── ScaffoldShowcaseView.swift     # 标杆级页面脚手架与段落容器全景展示
```

## 接入方式

### 1. Swift Package Manager 依赖引入

在 Xcode 中选择 **File > Add Package Dependencies...**，填入本仓库地址：
`https://github.com/18113996630/swiftui-components.git`

或在宿主工程的 `Package.swift` 中添加：

```swift
.package(url: "https://github.com/18113996630/swiftui-components.git", branch: "main")
```

在 Target 依赖中引入并在代码中导入：

```swift
import SwiftUI
import AuraDesignSystem
```

### 2. 🤖 让 AI 助手接入业务工程 (AI-Driven Integration Guide)

若你需要通过 **AI 编程助手**（如 Antigravity、Claude Code、Cursor、Windsurf 等）在其他业务项目中无缝接入并消费本组件库，请参阅：
👉 **[AI 接入与协同规范全流程指南 (`docs/AI_INTEGRATION_GUIDE.md`)](docs/AI_INTEGRATION_GUIDE.md)**

> 💡 **免维护机制**：本组件库推荐采用 **SPM 本地包自省模式（Local Package Inspection）**。业务工程的 `AGENTS.md` 无需复制粘贴组件清单，只需配置 10 行动态指针，让 AI 直接读取本地 SPM 检出的 `AI_INTEGRATION_GUIDE.md`。组件库升级时文档随包自动对齐，**100% 杜绝文档过时与版本错配**。

该指南提供：
- 极简下游 AI 动态指针模板（直接复制至业务工程 `.cursorrules` / `AGENTS.md`）
- 官方全量组件能力速查全景字典（防止 AI 幻觉与重复自造轮子）
- 国际化双通道分流规范（`LocalizedStringKey` 自动提取 vs `verbatim:` 直出）
- 常见翻车反模式与标准修复对照（Bad vs Good）

### 3. 标杆级页面搭建范式 (Scaffold & Section)

使用组件库内置的页面级与段落级脚手架，无需手动配平边距与背景，默认产出符合 HIG 律动的高级质感：

```swift
struct MyScheduleView: View {
    @State private var taskDone = false

    var body: some View {
        AuraScaffold {
            AuraSection(
                "今日日程",
                icon: "calendar",
                badgeText: "进行中"
            ) {
                BaseCard {
                    TimelineTaskRow(
                        time: "09:30",
                        timeRange: "09:30 - 10:30 (1小时)",
                        title: "核心系统架构设计",
                        icon: "laptopcomputer",
                        isCompleted: $taskDone
                    )
                }
            }
        }
        .themePalette(.teal) // 多巴胺活力主题穿透换肤
    }
}
```

### 国际化最佳实践 (String Catalog 自动抓取与 Verbatim 直出)

组件库遵循 Apple 原生 SwiftUI 签名设计，对所有包含文本的组件提供 `LocalizedStringKey` 与 `verbatim: String` 双通道：

#### 1. 本地化字面量（Xcode 15+ String Catalog 全自动静态提取）

编写 UI 代码时直接使用字符串字面量或 Apple 原生未具名签名，Xcode 会在编译阶段由 AST 扫描器自动将文本提取到宿主工程的 `Localizable.xcstrings` 中：

```swift
// 1. 原生声明式提取
AuraSection("Upcoming Tasks", icon: "sparkles", badgeText: "Today") {
    SettingsRow(
        icon: "bell.badge.fill",
        iconColor: .orange,
        title: "Daily Notification",
        subtitle: "Send soft haptics 15m before event",
        badgeText: "PRO"
    )
}

// 2. 交互控件与空状态自动提取
PillButton("Create New Script", icon: "plus") { ... }
NoticeBanner(style: .info, "Cloud sync complete", actionTitle: "View")
```

#### 2. 动态运行时数据直出（Verbatim 模式）

对于来自服务器 API、用户输入或非本地化的动态字符串，使用 `verbatim:` 初始化器原样直出，避免查表开销与漏译警告：

```swift
// 动态非本地化用户名或文件夹名称
AuraSection(verbatim: userFolder.title, icon: "folder") {
    SettingsRow(
        verbatim: account.displayName,
        subtitle: account.email
    )
}
```

#### 3. 零内置文案哲学（状态优先以图标呈现）

组件库坚持 100% 通用化，**不内置任何写死的业务自然语言文案**：
- **状态指示器**：如 `TypewriterStreamingCard` 的“生成中”状态默认通过呼吸闪烁圆点与动效直接表达，无需绑定语言；
- **通用功能按键**：如 `KeyboardAccessoryBar` 的收起键盘按键默认采用 `keyboard.chevron.compact.down` 纯图标；如需文字可由外部显式传入 `doneTitle: "Done"`；
- **业务微标**：如 `SettingsRow` 的徽标由 `badgeText` 参数完全托管，由业务方决定展示 `"PRO"`、`"VIP"` 还是 `"NEW"`。

## 本地构建与验证

```bash
swift build
```
