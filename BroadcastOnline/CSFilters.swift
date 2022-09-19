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
    case oneHours
    case threeHours
    case sixHours
    case twelveHours
    case oneDay
    
    func getModel() -> CSFilterItem {
        switch self {
        case .allLive: return CSFilterItem(title: "Лайв", type: .live)
        case .allPrematch: return CSFilterItem(title: "Все", type: .prematch)
        case .oneHours: return CSFilterItem(title: "1ч", type: .prematch)
        case .threeHours: return CSFilterItem(title: "3ч", type: .prematch)
        case .sixHours: return CSFilterItem(title: "6ч", type: .prematch)
        case .twelveHours: return CSFilterItem(title: "12ч", type: .prematch)
        case .oneDay: return CSFilterItem(title: "24ч", type: .prematch)
        }
    }
    
    func getValue() -> String {
        switch self {
        case .allLive:       return "all"
        case .allPrematch:   return "all"
        case .oneHours:      return "1_hours"
        case .threeHours:    return "3_hours"
        case .sixHours:      return "6_hours"
        case .twelveHours:   return "12_hours"
        case .oneDay:       return "1_days"
        }
    }
}
