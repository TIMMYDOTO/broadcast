//
//  CSTournament.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSTournament {
    ///entity
    var info: CSTournamentInfo = CSTournamentInfo()
    var matches: [CSMatch] = []
    
    ///extra
    var collapsed: Bool = false
}

extension CSTournament {
    static func entity(from: Bb_Mobile_OddinTreeWs_Tournament) -> Self {
        var entity = CSTournament()
        entity.info = CSTournamentInfo.entity(from: from.info)
        entity.matches = from.matches.map { CSMatch.entity(from: $0) }
        return entity
    }
}

// MARK: Info
struct CSTournamentInfo {
    var id: String = String()
    var sportId: String = String()
    var name: String = String()
    var abbreviation: String = String()
    var order: Int32 = 0
    var iconPath: String = String()
    var matchesCount: Int32 = 0
}

extension CSTournamentInfo {
    static func entity(from: Bb_Mobile_OddinTreeWs_Tournament.TournamentInfo) -> Self {
        var entity = CSTournamentInfo()
        entity.id = from.id
        entity.sportId = from.sportID
        entity.name = from.name
        entity.abbreviation = from.abbreviation
        entity.order = from.order
        entity.iconPath = from.iconPath
        entity.matchesCount = from.matchesCount
        return entity
    }
}
