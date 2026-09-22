import SwiftUI

/// 带有删除功能的标签胶囊（Aura 风格）
///
/// 常用于已选话题标签（如 #职场干货）、自定义禁用词或分发渠道标签。
/// 全面支持 Xcode 15+ String Catalog (`.xcstrings`) 自动静态提取与 `verbatim:` 动态非本地化直出。
///
/// ⚠️ 设计系统红线（Design Guardrails）：
/// 1. 【零内置文案】：标签内容不内置任何写死文本，由外部数据驱动；
/// 2. 【删除轻触感】：点击删除图标自动触发轻微轻触觉震动反馈；
/// 3. 【无二次透明稀释】：主文案采用 `textPrimary`，前缀符号采用强调色，严格对齐 WCAG 4.5:1。
///
/// ```swift
/// // 1. 本地化字面量（Xcode 自动提取）
/// DeletableChip("tag_growth", prefix: "#") {
///     removeTag()
/// }
///
/// // 2. 动态集合直出（Verbatim 模式）
/// ForEach(tags, id: \.self) { tag in
///     DeletableChip(verbatim: tag) {
///         delete(tag)
///     }
/// }
/// ```
public struct DeletableChip: View {
    @Environment(\.themePalette) private var themePalette

    private let title: LocalizedText
    private let prefix: String?
    private let customColor: Color?
    private let onDelete: () -> Void

    /// 本地化初始化器（Apple 原生风格）
    public init(
        _ title: LocalizedStringKey,
        prefix: String? = "#",
        color: Color? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.title = .localized(title)
        self.prefix = prefix
        self.customColor = color
        self.onDelete = onDelete
    }

    /// 具名本地化初始化器
    public init(
        title: LocalizedStringKey,
        prefix: String? = "#",
        color: Color? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.init(title, prefix: prefix, color: color, onDelete: onDelete)
    }

    /// 动态非本地化直出初始化器
    public init(
        verbatim title: String,
        prefix: String? = "#",
        color: Color? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.title = .verbatim(title)
        self.prefix = prefix
        self.customColor = color
        self.onDelete = onDelete
    }

    private var effectiveColor: Color {
        customColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: 5) {
            if let prefix {
                Text(prefix)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(effectiveColor)
                    .fontWeight(.bold)
            }

            title.makeText()
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Color.textPrimary)
                .fontWeight(.medium)

            Button(action: {
                HapticManager.impact(.light)
                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                    onDelete()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Color.textTertiary)
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.leading, prefix != nil ? 10 : 12)
        .padding(.trailing, 4)
        .padding(.vertical, 4)
        .background(DesignSystem.Color.fillSecondary)
        .clipShape(Capsule())
        .contentShape(Capsule())
    }
}

#Preview("DeletableChip Demo") {
    DeletableChipPreviewHelper()
}

private struct DeletableChipPreviewHelper: View {
    @State private var tags = ["个人成长", "创业复盘", "高效提词", "AI赋能", "时间管理"]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Text("DeletableChip (可删除标签)")
                .font(DesignSystem.Typography.headline)

            FlowLayout(horizontalSpacing: 8, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    DeletableChip(verbatim: tag) {
                        tags.removeAll { $0 == tag }
                    }
                }
            }
        }
        .padding()
        .themePalette(.coral)
    }
}
