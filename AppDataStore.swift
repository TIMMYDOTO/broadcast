//
//  AppDataStore.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 01.06.2022.
//

import Foundation
import UIKit

final class AppDataStore {
  
    static let shared = AppDataStore()
    
    var appConfig = AppConfig()
    
    var favoriteGameProduct = ""
    
    var appGlobalInset: UIEdgeInsets = .zero
    
    var isBetInProgress = false
    
}
