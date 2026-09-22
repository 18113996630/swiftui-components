# swiftui-components

一个面向 iOS 18+ 的 SwiftUI 结构化设计系统（StructuredDesignSystem），以 ADA 获奖级视觉基调为准则，提供统一的设计令牌、原子微标、交互选择器、流式排版与浮岛卡片容器，便于多个独立应用保持高度视觉一致性与细腻交互手感。

## 设计系统核心规范 (Design DNA)

1. **全域 SF Pro Rounded 排版与 WCAG 4.5:1 对比度基准**：温暖、圆润且高辨识度，涵盖 `largeTitle` (28pt)、`title` (20pt)、`headline` (17pt Semibold 骨架)、`body` (16pt Regular)、`subheadline` (14pt Medium)、`caption` 与 `time` (13pt Semibold)，严禁二次透明度稀释，告别发灰发虚。
2. **连续曲率超椭圆 (Continuous Curvature)**：全系采用 `.continuous`，梯度覆盖 8pt (微标) / 14pt (按钮) / 20pt (卡片) / 28pt (浮岛主画布)。
3. **9 色多巴胺活力主题色盘**：`ThemePalette` 贯穿，通过 `@Environment(\.themePalette)` 全局穿透与即时换肤。
4. **漫反射环境光阴影与细微边缘**：统一 `24pt / 32pt` 柔和扩散阴影与 `0.5pt hairlineBorder` 边缘高光。
5. **物理弹性缩放与细腻触觉**：统一 `ScaleButtonStyle` (0.97 按压缩放) 与集中式 `HapticManager` 机械震动反馈。

## 目录结构

```text
Sources/StructuredDesignSystem/
├── DesignSystem.swift              # 主题调色盘、颜色、字体、间距、圆角、漫反射阴影令牌
├── Theme/
│   └── ThemeEnvironment.swift      # @Environment(\.themePalette) 全局动态主题穿透
├── Extensions/
│   └── View+DesignSystem.swift     # .structuredCard() / .fadeEdge() / .ambientShadow() / .hairlineBorder()
├── Styles/
│   ├── ScaleButtonStyle.swift     # 弹性物理微缩触感样式 (.scale)
│   └── HapticManager.swift         # 集中式触觉震动管理器 (Impact / Notification / Selection)
├── Components/
│   ├── BaseCard.swift              # 浮岛卡片容器 (支持 20/28pt、内边距与细边框)
│   ├── FlowLayout.swift            # 原生流式折行布局协议 (iOS 16+)
│   ├── PillBadge.swift             # 纯展示型语义彩色微标 (.subtle / .solid / .neutral)
│   ├── PillButton.swift            # 胶囊微交互标签按键
│   ├── SelectableChip.swift        # 状态多选/单选胶囊芯片 (带 Checkmark 动画)
│   ├── DeletableChip.swift         # 可删除标签胶囊 (#话题标签与禁用词)
│   ├── PillSegmentedPicker.swift   # 软底胶囊分段选择器
│   ├── UnderlinedTabBar.swift      # 极简纯文字下划线导航 Tab 栏
│   ├── PagingIndicatorCapsule.swift # 物理弹性伸缩胶囊分页指示器 (支持数字胶囊)
│   ├── PrecisionSliderRow.swift    # 等宽数值微调滑杆行 (带 .monospacedDigit 微标)
│   ├── SFSymbolGridPicker.swift    # SF Symbol 图标矩阵选择器
│   ├── PaletteColorPicker.swift    # ConcentricColorCircle / ColorPickerRow / 9色主题拾取
│   ├── HIGSectionHeaderView.swift  # 表单与分组标准头部视图 (带图标底座与微标)
│   ├── SettingsRow.swift           # 标准表单行 (支持泛型 trailing、Toggle 与副标题)
│   ├── ClearableTextFieldRow.swift # 卡片式带清空与快捷粘贴输入行
│   ├── FormRowActionButton.swift  # 表单居中功能与危险操作按钮
│   ├── KeyboardAccessoryBar.swift  # 键盘快捷辅助工具栏 (含字数统计)
│   ├── ToastHUD.swift              # 毛玻璃悬浮轻提示与 .toastHUD(...) 修饰符
│   ├── NoticeBanner.swift          # 信息/警示/错误通栏提示卡片
│   ├── StructuredScaffold.swift    # 标杆级全屏页面脚手架 (自动管理 16pt 外边距与 24pt 段落流)
│   ├── StructuredSection.swift     # 标杆级段落分组容器 (集成 HIG 标头与 12pt 内边距)
│   ├── EmptyStateView.swift        # 标杆级居中空状态视图
│   ├── TypewriterStreamingCard.swift # 打字机流式生成与呼吸光标卡片
│   ├── TimelineTaskRow.swift       # 38pt 饱满时间线节点与虚线空闲时段
│   ├── ChecklistRow.swift          # 子任务与待办清单行
│   └── HeroBannerSheet.swift       # 沉浸式彩色顶栏模态卡片
└── Previews/
    ├── DesignSystemGalleryView.swift # 全景交互式组件展厅 (包含全量组件与即时换肤)
    ├── TypographyShowcaseView.swift   # 排版字阶与 WCAG 4.5:1 对比度规范专项展示
    └── ScaffoldShowcaseView.swift     # 标杆级页面脚手架与段落容器全景展示
```

## 接入方式

### Swift Package Manager

在 Xcode 中选择 **File > Add Package Dependencies...**，然后填入本仓库地址。

也可以在 `Package.swift` 中添加：

```swift
.package(url: "https://github.com/your-org/swiftui-components.git", from: "0.2.0")
```

在代码中引入：

```swift
import SwiftUI
import StructuredDesignSystem
```

### 标杆级页面搭建范式 (Scaffold & Section)

使用组件库内置的页面级与段落级脚手架，无需手动配平边距与背景，默认产出符合 HIG 律动的高级质感：

```swift
struct MyScheduleView: View {
    @State private var taskDone = false

    var body: some View {
        StructuredScaffold {
            StructuredSection(
                title: "今日日程",
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

## 本地构建与验证

```bash
xcodebuild \
  -scheme StructuredDesignSystem \
  -destination "generic/platform=iOS" \
  build
```
