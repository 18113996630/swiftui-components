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
└── INTEGRATION_GUIDE.md           # 组件库接入与协同规范全流程指南 (单一真实源 SSOT)

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

### 2. 🤖 让 AI 助手接入业务工程 (Integration Guide)

若你需要通过 **AI 编程助手**（如 Antigravity、Claude Code、Cursor、Windsurf 等）在其他业务项目中无缝接入并消费本组件库，请直接参阅：
👉 **[组件库接入与协同规范全流程指南 (`docs/INTEGRATION_GUIDE.md`)](docs/INTEGRATION_GUIDE.md)**

> 💡 **单一真实源（SSOT）与免维护机制**：本组件库所有全量组件速查字典、参数说明与防翻车守则**全在 `docs/INTEGRATION_GUIDE.md` 闭环维护**。下游工程采用 **SPM 本地包自省模式**，只需在业务工程的 `AGENTS.md` 配置 10 行动态指针即可，组件库升级时文档随包自动对齐，**100% 杜绝文档过时与版本错配**。

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

### 4. 国际化与零内置文案规范 (i18n & Zero Copy)

组件库遵循 Apple 原生 SwiftUI 签名设计，对所有包含文本的组件提供 `LocalizedStringKey` 与 `verbatim: String` 双通道：

- **静态字面量（Xcode 15+ String Catalog 自动静态提取）**：编写 UI 时直接传字符串字面量（如 `AuraSection("Settings")`），由 Xcode 编译期 AST 扫描器自动提取到宿主工程的 `Localizable.xcstrings`；
- **动态数据直出（Verbatim 模式）**：网络 API 或用户输入变量调用 `verbatim:` 参数（如 `SettingsRow(verbatim: user.name)`），防止编译错误与查表开销；
- **零内置文案闭环**：组件库内部 100% 不内置死锁文案，状态与指示器优先采用原生 SF Symbols 与微动效表达。

> 📖 **完整全量组件速查字典与详细调用代码，请统一查阅单一真实源**：
> 👉 **[`docs/INTEGRATION_GUIDE.md`](docs/INTEGRATION_GUIDE.md)**

## 本地构建与验证

```bash
swift build
```
