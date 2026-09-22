import SwiftUI

// MARK: - Theme Environment Key
private struct ThemePaletteKey: EnvironmentKey {
    static let defaultValue: ThemePalette = .berry
}

public extension EnvironmentValues {
    /// 当前视图层级绑定的主题色盘（默认: .berry 浆果红）
    var themePalette: ThemePalette {
        get { self[ThemePaletteKey.self] }
        set { self[ThemePaletteKey.self] = newValue }
    }
}

public extension View {
    /// 为当前视图及其所有子视图注入全局主题色盘
    /// - Parameter palette: 选定的 ThemePalette 9 色主题
    func themePalette(_ palette: ThemePalette) -> some View {
        environment(\.themePalette, palette)
    }
}
