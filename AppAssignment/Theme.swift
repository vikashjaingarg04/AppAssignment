import SwiftUI

enum ThemeMode: Int, CaseIterable, Identifiable { case system = 0, light = 1, dark = 2; var id: Int { rawValue } }

struct ThemePalette {
    let appBackground: Color
    let cardBackground: Color
    let cardStroke: Color
    let elevatedBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let accent: Color
    let success: Color
    let danger: Color
    let tabBarBackground: Color
    let pillBackground: Color
    let buttonPrimaryBackground: Color
    let buttonPrimaryForeground: Color
}

final class ThemeManager: ObservableObject {
    @AppStorage("theme_mode") private var storedMode: Int = ThemeMode.system.rawValue
    @Published var selectedMode: ThemeMode = .system {
        didSet { storedMode = selectedMode.rawValue }
    }

    init() {
        selectedMode = ThemeMode(rawValue: storedMode) ?? .system
    }

    var activeColorScheme: ColorScheme? {
        switch selectedMode {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var palette: ThemePalette { ThemeManager.palette(for: selectedMode) }

    static func palette(for mode: ThemeMode) -> ThemePalette {
        switch mode {
        case .light, .system:
            // In system mode, these colors will still look good in light scheme.
            return ThemePalette(
                appBackground: Color(UIColor.systemGroupedBackground),
                cardBackground: Color(UIColor.secondarySystemBackground),
                cardStroke: Color.black.opacity(0.06),
                elevatedBackground: Color(UIColor.systemBackground),
                primaryText: .black,
                secondaryText: .gray,
                accent: Color(red: 0.25, green: 0.35, blue: 1.0),
                success: .green,
                danger: .red,
                tabBarBackground: Color.white.opacity(0.96),
                pillBackground: Color.black.opacity(0.08),
                buttonPrimaryBackground: Color(red: 0.25, green: 0.35, blue: 1.0),
                buttonPrimaryForeground: .white
            )
        case .dark:
            return ThemePalette(
                appBackground: Color(red: 0.07, green: 0.07, blue: 0.07), // ~#121212
                cardBackground: Color.white.opacity(0.06),
                cardStroke: Color.white.opacity(0.10),
                elevatedBackground: Color.black.opacity(0.88),
                primaryText: .white,
                secondaryText: .white.opacity(0.7),
                accent: Color(red: 0.36, green: 0.33, blue: 1.0),
                success: .green,
                danger: .red,
                tabBarBackground: Color.black.opacity(0.88),
                pillBackground: Color.white.opacity(0.10),
                buttonPrimaryBackground: Color.blue,
                buttonPrimaryForeground: .white
            )
        }
    }
}


