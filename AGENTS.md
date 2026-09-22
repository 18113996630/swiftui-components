# AGENTS.md

本文档用于规范所有 AI 助手（Agents）以及开发人员在本仓库（`swiftui-components` / `AuraDesignSystem`）中的开发、重构与文档维护行为准则。

---

## 🚨 核心铁律：双重同步机制（Dual Synchronization Protocol）

> **红线原则 1（外部文档与 AI 知识源同步）**：**只要增加、删除、修改了任何 UI 组件、设计令牌或公开 API，必须在同一任务流程中同步更新 `README.md` 与 `docs/AI_INTEGRATION_GUIDE.md`（包含组件能力速查表与调用示例）。下游业务工程的 AI 依赖本地检出目录进行自省，严禁出现外部文档与实际用法脱节的情况。**
>
> **红线原则 2（源码注释同步）**：**只要增加、修改或重构了任何 UI 组件或公开 API，必须在同一任务流程中同步更新组件源码上方的 Swift DocComments（`///`），必须包含组件核心定位、⚠️ 设计系统红线（Design Guardrails）与最小可用示例代码块（```swift），严禁源码注释与代码实际行为脱节，确保下游消费系统与 AI 助手通过 LSP 能够获取精确的用法与设计约束。**

---

## 一、 组件变更维护清单（Checklist）

### 1. 新增组件（New Component）
- [ ] **源码 DocComments 注入**：新增组件必须配备结构化 `///` 注释，包含一句话职责定位、`⚠️ 设计系统红线（Design Guardrails）` 与包含标准调用方式的 `/// ```swift` 代码示例。
- [ ] **目录树与 AI 指南同步**：在 `README.md` 目录树中补全新增的 Swift 文件路径与核心定位；同时在 `docs/AI_INTEGRATION_GUIDE.md` 的「组件能力速查字典」表格中补齐分类、组件名、职责与最小调用代码。
- [ ] **展厅接入**：将新组件接入 [`DesignSystemGalleryView.swift`](Sources/AuraDesignSystem/Previews/DesignSystemGalleryView.swift) 或配套的专项 Specimen 视图中，确保有直观的交互预览。

### 2. 修改组件（Modify Component）
- [ ] **源码 DocComments 修正**：同步更新类型与初始化器上方的 `///` 注释，确保参数描述、`⚠️ 设计系统红线` 与 `/// ```swift` 代码示例与最新代码完全一致。
- [ ] **API 示例与速查表核验**：若修改了组件的初始化器参数（`init`）、样式枚举（如 `.subtle` / `.solid`）、环境键或关键修饰符，必须同步更新 `README.md` 和 `docs/AI_INTEGRATION_GUIDE.md` 中引用的调用示例。
- [ ] **破坏性变更提示**：若调整了默认参数或废弃了旧属性，必须在文档中明确更新后的调用方式，避免外部消费项目编译失败。

### 3. 删除/重命名组件（Delete / Rename Component）
- [ ] **目录树与速查表剔除**：立即从 `README.md` 目录树与 `docs/AI_INTEGRATION_GUIDE.md` 组件表中移除或更名对应组件，严禁遗留失效的组件声明。
- [ ] **清理陈旧引用**：清理文档中所有提及该组件的代码片段与描述文本。

### 4. 设计令牌变更（Design Tokens Update）
- [ ] **设计规范同步**：若在 `DesignSystem.swift` 中对色彩（`Color`）、字阶（`Typography`）、间距（`Spacing`）、圆角（`CornerRadius`）或阴影（`Shadow`）进行了增改或规范调优，必须同步更新 `README.md` 中的「设计系统核心规范 (Design DNA)」章节。

---

## 二、 设计与排版通用约束（Design System Rules）

在添加或重构 UI 组件时，AI 必须严格遵守以下已沉淀的人机交互与视觉规范：

1. **严格遵循 WCAG 4.5:1 对比度标准**：
   - 核心大标题与章节段落大标必须使用 `DesignSystem.Color.textPrimary`（`Color.primary`）撑起黑白骨架；
   - 次级说明文本使用 `DesignSystem.Color.textSecondary`（`Color.secondary`），**严禁在此基础上二次叠加 `.opacity(...)`**，避免造成文字发灰、发虚的视觉疲劳感；
   - 浮岛纯白卡片（`#FFFFFF`）作为文本保护仓，不可让大面积正文直接裸露在冷灰底板上。
2. **SF Pro Rounded 亲和字阶**：
   - 遵循统一字阶：`largeTitle` (28pt)、`title` (20pt)、`headline` (17pt Semibold)、`body` (16pt Regular)、`subheadline` (14pt Medium)、`caption` / `time` (13pt Medium/Semibold)。
3. **多巴胺活力主题穿透**：
   - 涉及主题色渲染的组件必须支持通过 `@Environment(\.themePalette)` 动态注入与响应换肤。
4. **人体工学与微交互**：
   - 交互按键默认绑定 `ScaleButtonStyle`（0.97 按压缩放）与 `HapticManager` 机械震动反馈，禁止生硬无反馈的状态跳变。

---

## 三、 提交通行准则（Pre-completion Verification）

每次完成代码与文档修改后，必须通过以下验证才可认定任务完成：
1. 运行 `swift build`，确保整个 Swift Package 处于 **0 错误、0 警告编译通过** 状态。
2. 核对 `git status` 与 `git diff`，确认代码变更与 `README.md` 的更新内容保持 100% 对齐。
