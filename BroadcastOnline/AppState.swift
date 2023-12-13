//
//  AppState.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 01.06.2022.
//

import Foundation
import UIKit

final class AppState {
    #if DEBUG
        let isDebug = true
    #else
        let isDebug = false
    #endif
  
    static let shared = AppState()
    
    
    
    var appConfig = AppConfig()
    
    
    
    var favoriteGameProduct = ""
    
    var appGlobalInset: UIEdgeInsets = .zero
    
    var isBetInProgress = false
    
    

    var maxCoefficient: Double = 15000
}
