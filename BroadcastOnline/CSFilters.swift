//
//  CSFilters.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSFilterItem {
    var title: String
    var type: SportLivePrematch
}

enum CSFilter: String {
    case allLive
    case allPrematch
    
    func getModel() -> CSFilterItem {
        
        switch self {
        case .allLive: return CSFilterItem(title: "LIVE", type: .live)
        case .allPrematch: return CSFilterItem(title: "Prematch", type: .prematch)

        }
    }
    
    func getValue() -> String {
        switch self {
        case .allLive:       return "all"
        case .allPrematch:   return "all"
     
        }
    }
}
