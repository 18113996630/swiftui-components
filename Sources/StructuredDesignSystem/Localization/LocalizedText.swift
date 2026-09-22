import SwiftUI

/// Structured 标杆级国际化双通道文本包装器
///
/// 专为现代化 SwiftUI 与 Xcode 15+ String Catalog (`.xcstrings`) 架构打造：
/// 1. 【本地化通道 (.localized)】：接收 `LocalizedStringKey`，由 Xcode 在编译期通过 AST 静态抓取入库，运行时自动跟随系统语言热重载；
/// 2. 【直出通道 (.verbatim)】：接收普通 `String`，专用于服务端动态数据、用户名、数字等非本地化运行时字符串，杜绝查表开销与漏译警告。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【严禁业务写死】：组件库内部严禁写死任何自然语言文本，所有展示型文本必须由外部业务方通过该双通道注入；
/// 2. 【字阶修饰连贯】：统一使用 `makeText() -> Text` 返回具体类型 `Text`，保留原生 `.font()`、`.foregroundColor()` 与排版修饰符的高性能链式调用；
/// 3. 【状态优先图标】：表示状态的场景（如“加载中”、“生成中”）首选图标与动效表达，避免强依赖语言文案。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// let title = LocalizedText.localized("section_tasks_title")
/// title.makeText().font(DesignSystem.Typography.headline)
///
/// // 2. 动态非本地化直出
/// let username = LocalizedText.verbatim(user.fullName)
/// username.makeText().font(DesignSystem.Typography.body)
/// ```
@frozen
public enum LocalizedText: @unchecked Sendable {
    case localized(LocalizedStringKey)
    case verbatim(String)

    /// 构造本地化键文本容器
    public init(_ key: LocalizedStringKey) {
        self = .localized(key)
    }

    /// 构造非本地化原样直出文本容器
    public init(verbatim string: String) {
        self = .verbatim(string)
    }

    /// 渲染为 SwiftUI 原生 `Text` 视图，保留所有原生 Text 修饰符能力
    public func makeText() -> Text {
        switch self {
        case .localized(let key):
            return Text(key)
        case .verbatim(let string):
            return Text(verbatim: string)
        }
    }
}

extension LocalizedText: View {
    public var body: some View {
        makeText()
    }
}
