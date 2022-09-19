//
//  CSSport.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.03.2022.
//

import Foundation

struct CSSport {
    var info: CSSportInfo = CSSportInfo()
    var tournaments: [CSTournament] = []
}

extension CSSport {
    static func entity(from: Bb_Mobile_OddinTreeWs_Sport) -> Self {
        var entity = CSSport()
        entity.info = CSSportInfo.entity(from: from.info)
        entity.tournaments = from.tournaments.map { CSTournament.entity(from: $0) }
        return entity
    }
}

// MARK: Info
struct CSSportInfo {
    ///entity
    var id: String = String()
    var name: String = String()
    var abbreviation: String = String()
    var order: Int32 = 0
    var iconPath: String = String()
    var matchesCount: Int32 = 0
    var minPrematchMatchStartDttm: String = String()
    
    ///extra
    var hasLive: Bool = false
}

extension CSSportInfo {
    static func entity(from: Bb_Mobile_OddinTreeWs_Sport.SportInfo) -> Self {
        var entity = CSSportInfo()
        entity.id = from.id
        entity.name = from.name
        entity.abbreviation = from.abbreviation
        entity.order = from.order
        entity.iconPath = from.iconPath
        entity.matchesCount = from.matchesCount
        entity.minPrematchMatchStartDttm = from.minPrematchMatchStartDttm
        return entity
    }
}
