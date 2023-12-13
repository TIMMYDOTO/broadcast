//
//  BBThemes.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 06.04.2021.
//

import SwiftTheme
import Foundation

enum BBTheme: Int {
    
    case night = 0
    case day = 1
    
    static func switchTo(theme: BBTheme) {
        ThemeManager.setTheme(index: theme.rawValue)
    }
    
    static func isNight() -> Bool {
        guard let lastTheme = BBTheme(rawValue: UserDefaults.standard.integer(forKey: "lastThemeIndexKey")) else { return true }
        
        return lastTheme == .night
    }
    
    static func restoreLastTheme() {
        ThemeManager.animationDuration  = 0
        
        guard let lastTheme = BBTheme(rawValue: UserDefaults.standard.integer(forKey: "lastThemeIndexKey")) else { return }
        
        switchTo(theme: lastTheme)
    }
    
    static func saveLastTheme() {
        UserDefaults.standard.set(ThemeManager.currentThemeIndex, forKey: "lastThemeIndexKey")
    }
}
