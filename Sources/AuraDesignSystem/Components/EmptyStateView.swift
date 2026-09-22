import SwiftUI

/// 标杆级居中空状态视图（Aura 风格）
///
/// 严格贴合规范：大图标柔和底座 + SF Pro Rounded 标题 + 辅助说明文案 + 可选操作动作插槽。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：空状态标题与辅助说明文案严禁在组件内写死，必须由消费方传入；
/// 2. 【对比度分层】：大标题强制采用 `textPrimary`，描述采用 `textSecondary`，杜绝多层透明度发灰；
/// 3. 【多巴胺圆底】：图标底座统一使用 72x72pt 12% 浅透明多巴胺底座，视觉中心平衡。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// EmptyStateView(
///     icon: "doc.text.magnifyingglass",
///     title: "empty_scripts_title",
///     description: "empty_scripts_desc"
/// ) {
///     PillButton("action_create_script", icon: "plus") {}
/// }
///
/// // 2. 动态非本地化直出
/// EmptyStateView(
///     icon: "folder",
///     verbatim: "No files in \(folderName)",
///     description: "Upload a file to start"
/// )
/// ```
public struct EmptyStateView<ActionContent: View>: View {
    @Environment(\.themePalette) private var themePalette

    private let icon: String
    private let title: LocalizedText
    private let description: LocalizedText?
    private let iconColor: Color?
    private let action: ActionContent

    /// 本地化初始化器（Apple 原生风格）
    public init(
        icon: String,
        _ title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        iconColor: Color? = nil,
        @ViewBuilder action: () -> ActionContent
    ) {
        self.icon = icon
        self.title = .localized(title)
        self.description = description.map { .localized($0) }
        self.iconColor = iconColor
        self.action = action()
    }

    /// 具名本地化初始化器
    public init(
        icon: String,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        iconColor: Color? = nil,
        @ViewBuilder action: () -> ActionContent
    ) {
        self.init(icon: icon, title, description: description, iconColor: iconColor, action: action)
    }

    /// 动态非本地化直出初始化器
    public init(
        icon: String,
        verbatim title: String,
        description: String? = nil,
        iconColor: Color? = nil,
        @ViewBuilder action: () -> ActionContent
    ) {
        self.icon = icon
        self.title = .verbatim(title)
        self.description = description.map { .verbatim($0) }
        self.iconColor = iconColor
        self.action = action()
    }

    private var effectiveColor: Color {
        iconColor ?? themePalette.color
    }

    public var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // 大图标柔和底座
            ZStack {
                Circle()
                    .fill(effectiveColor.opacity(0.12))
                    .frame(width: 72, height: 72)

                Image(systemName: icon)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(effectiveColor)
            }

            VStack(spacing: DesignSystem.Spacing.tiny) {
                title.makeText()
                    .font(DesignSystem.Typography.title)
                    .foregroundColor(DesignSystem.Color.textPrimary)

                if let description {
                    description.makeText()
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                }
            }

            action
        }
        .padding(DesignSystem.Layout.cardPadding)
        .frame(maxWidth: .infinity)
    }
}

public extension EmptyStateView where ActionContent == EmptyView {
    init(
        icon: String,
        _ title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        iconColor: Color? = nil
    ) {
        self.init(icon: icon, title, description: description, iconColor: iconColor) {
            EmptyView()
        }
    }

    init(
        icon: String,
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        iconColor: Color? = nil
    ) {
        self.init(icon: icon, title, description: description, iconColor: iconColor) {
            EmptyView()
        }
    }

    init(
        icon: String,
        verbatim title: String,
        description: String? = nil,
        iconColor: Color? = nil
    ) {
        self.init(icon: icon, verbatim: title, description: description, iconColor: iconColor) {
            EmptyView()
        }
    }
}

#Preview("EmptyStateView Preview") {
    ZStack {
        DesignSystem.Color.background.ignoresSafeArea()

        VStack {
            BaseCard {
                EmptyStateView(
                    icon: "doc.text.magnifyingglass",
                    title: "暂无提词文稿",
                    description: "点击下方按钮开始创作你的第一篇口播文案，或直接导入链接。"
                ) {
                    PillButton("新建提词脚本", icon: "plus", action: {})
                }
            }
        }
        .padding(DesignSystem.Layout.pagePadding)
        .themePalette(.teal)
    }
}
