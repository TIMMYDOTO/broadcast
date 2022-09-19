//
//  CSPeriodScore.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSPeriodScore: Codable, Hashable {
    var type: String = String()
    var number: Int32 = 0
    var matchStatus: String = String()
    var hasScores: Bool = false
    var homeScore: Int32 = 0
    var awayScore: Int32 = 0
    var hasKills: Bool = false
    var homeKills: Int32 = 0
    var awayKills: Int32 = 0
    var hasWondRounds: Bool = false
    var homeWonRounds: Int32 = 0
    var awayWonRounds: Int32 = 0
    var hasGoalds: Bool = false
    var homeGoals: Int32 = 0
    var awayGoals: Int32 = 0
}

extension CSPeriodScore {
    static func entity(from: Bb_Mobile_OddinTreeWs_Match.PeriodScore) -> Self {
        var entity = CSPeriodScore()
        entity.type = from.type
        entity.number = from.number
        entity.matchStatus = from.matchStatus
        entity.hasScores = from.hasHomeScore && from.hasAwayScore
        entity.homeScore = from.homeScore
        entity.awayScore = from.awayScore
        entity.hasKills = from.hasHomeKills && from.hasAwayKills
        entity.homeKills = from.homeKills
        entity.awayKills = from.awayKills
        entity.hasWondRounds = from.hasHomeWonRounds && from.hasAwayWonRounds
        entity.homeWonRounds = from.homeWonRounds
        entity.awayWonRounds = from.awayWonRounds
        entity.hasGoalds = from.hasHomeGoals && from.hasAwayGoals
        entity.homeGoals = from.homeGoals
        entity.awayGoals = from.awayGoals
        return entity
    }
    
    static func entity(from: Bb_BetsHistoryV3GetEventResultResponse.EventResult.PeriodScore) -> Self {
        var entity = CSPeriodScore()
        entity.type = from.type
        entity.number = from.number
        entity.matchStatus = from.matchStatus
        entity.hasScores = true
        entity.homeScore = from.homeScore
        entity.awayScore = from.awayScore
        entity.hasKills = from.hasHomeKills && from.hasAwayKills
        entity.homeKills = from.homeKills
        entity.awayKills = from.awayKills
        entity.hasWondRounds = from.hasHomeWonRounds && from.hasAwayWonRounds
        entity.homeWonRounds = from.homeWonRounds
        entity.awayWonRounds = from.awayWonRounds
        entity.hasGoalds = from.hasHomeGoals && from.hasAwayGoals
        entity.homeGoals = from.homeGoals
        entity.awayGoals = from.awayGoals
        return entity
    }
    
    func getScores(property: FavoritePeriodScoreProperties) -> (home: Int32, away: Int32) {
        switch property {
        case .goals: return (homeGoals, awayGoals)
        case .kills: return (homeKills, awayKills)
        case .rounds: return (homeWonRounds, awayWonRounds)
        case .score: return (homeScore, awayScore)
        }
    }
    
    func hasScores(property: FavoritePeriodScoreProperties) -> Bool {
        switch property {
        case .goals: return hasGoalds
        case .kills: return hasKills
        case .rounds: return hasWondRounds
        case .score: return hasScores
        }
    }
}

