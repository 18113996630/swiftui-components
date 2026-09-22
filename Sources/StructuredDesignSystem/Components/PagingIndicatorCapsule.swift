import SwiftUI

/// 标杆级物理伸缩胶囊分页指示器（Structured 风格）
/// 激活项呈现为 18x5pt 连续圆角胶囊，非激活项为 5x5pt 微圆点，翻页带物理弹簧拉伸动画
public struct PagingIndicatorCapsule: View {
    @Environment(\.themePalette) private var themePalette

    @Binding private var currentPage: Int
    private let totalPages: Int
    private let showFractionLabel: Bool
    private let customActiveColor: Color?

    public init(
        currentPage: Binding<Int>,
        totalPages: Int,
        showFractionLabel: Bool = false,
        activeColor: Color? = nil
    ) {
        self._currentPage = currentPage
        self.totalPages = totalPages
        self.showFractionLabel = showFractionLabel
        self.customActiveColor = activeColor
    }

    private var effectiveActiveColor: Color {
        customActiveColor ?? themePalette.color
    }

    public var body: some View {
        HStack(spacing: 8) {
            // 胶囊原点群
            HStack(spacing: 5) {
                ForEach(0..<totalPages, id: \.self) { index in
                    let isSelected = currentPage == index

                    Button(action: {
                        guard currentPage != index else { return }
                        HapticManager.selection()
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
                            currentPage = index
                        }
                    }) {
                        Capsule()
                            .fill(isSelected ? effectiveActiveColor : SwiftUI.Color.gray.opacity(0.3))
                            .frame(width: isSelected ? 18 : 5, height: 5)
                            .frame(minWidth: isSelected ? 24 : 14, minHeight: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            // 可选的数字分数微胶囊 "2 / 7"
            if showFractionLabel {
                Text("\(currentPage + 1) / \(totalPages)")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Color.textSecondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("PagingIndicatorCapsule Demo") {
    PagingIndicatorPreviewHelper()
}

private struct PagingIndicatorPreviewHelper: View {
    @State private var page = 1

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Text("PagingIndicatorCapsule (弹性分页指示器)")
                .font(DesignSystem.Typography.headline)

            PagingIndicatorCapsule(
                currentPage: $page,
                totalPages: 5,
                showFractionLabel: true
            )

            HStack(spacing: 20) {
                Button("上一页") {
                    if page > 0 { page -= 1 }
                }
                Button("下一页") {
                    if page < 4 { page += 1 }
                }
            }
            .font(DesignSystem.Typography.caption)
        }
        .padding()
        .themePalette(.amber)
    }
}
