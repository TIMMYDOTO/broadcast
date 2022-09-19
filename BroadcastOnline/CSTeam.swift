//
//  CSTeam.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSTeam: Codable, Hashable {
    var home: Bool = false
    var name: String = String()
    var abbreviation: String = String()
    var score: Int32 = 0
    var image: String = String()
}

extension CSTeam {
    static func entity(from: Bb_Mobile_OddinTreeWs_Match.Team) -> Self {
        var entity = CSTeam()
        entity.home = from.home
        entity.name = from.name
        entity.abbreviation = from.abbreviation
        entity.score = from.score
        entity.image = from.image
        return entity
    }
    
    static func entity(from: Bb_BetsHistoryV3GetEventResultResponse.EventResult.Team) -> Self {
        var entity = CSTeam()
        entity.home = from.home
        entity.name = from.name
        entity.abbreviation = from.name
        entity.score = from.score
        entity.image = from.image
        return entity
    }
}

