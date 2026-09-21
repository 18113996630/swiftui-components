# swiftui-components

一个面向 iOS 15+ 的 SwiftUI 结构化设计系统，提供统一的设计令牌与可复用组件，便于多个项目快速接入并保持视觉一致。

## 目录结构

```text
Sources/StructuredDesignSystem/
├── DesignSystem.swift              # 颜色、字体、间距、圆角、阴影、布局与动效令牌
├── Styles/ScaleButtonStyle.swift   # 按压缩放、透明度与触觉反馈
└── Components/
    ├── BaseCard.swift              # 基础卡片容器
    ├── IconBadge.swift             # 图标徽章
    ├── PillButton.swift            # 胶囊按钮
    ├── TimelineTaskRow.swift       # 时间线任务行
    └── SettingsRow.swift           # 设置列表行
```

## 接入方式

### Swift Package Manager

在 Xcode 中选择 **File > Add Package Dependencies...**，然后填入本仓库地址。

也可以在 `Package.swift` 中添加：

```swift
.package(url: "https://github.com/your-org/swiftui-components.git", from: "0.1.0")
```

最后在需要使用的文件中引入：

```swift
import StructuredDesignSystem
```

## 使用示例

```swift
import SwiftUI
import StructuredDesignSystem

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Layout.sectionSpacing) {
                BaseCard {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("今日焦点")
                            .font(DesignSystem.Typography.headline)

                        Text("完成组件库重构并发布 1.0.0 版本")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Color.textSecondary)
                    }
                }

                TimelineTaskRow(
                    time: "09:00",
                    title: "晨会",
                    subtitle: "同步项目进度",
                    icon: "person.2.fill",
                    color: .blue,
                    isLast: false
                )

                SettingsRow(
                    icon: "bell.fill",
                    iconColor: .green,
                    title: "通知与提醒"
                ) {
                    print("点击了通知")
                }
            }
            .padding(DesignSystem.Layout.pagePadding)
        }
        .background(DesignSystem.Color.background)
    }
}
```

## 本地构建

```bash
xcodebuild \
  -scheme StructuredDesignSystem \
  -destination "generic/platform=iOS" \
  build
```
