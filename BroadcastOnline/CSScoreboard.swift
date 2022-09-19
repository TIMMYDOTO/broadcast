//
//  CSScoreboard.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSScoreboard: Codable, Hashable {
    var currentCtTeam: CTTeam?
    var currentRound: Int32 = 0
    var hasDestroyedTowersScore: Bool = false
    var homeDestroyedTowers: Int32 = 0
    var awayDestroyedTowers: Int32 = 0
    var hasDestroyedTurretsScore: Bool = false
    var homeDestroyedTurrets: Int32 = 0
    var awayDestroyedTurrets: Int32 = 0
    var hasGoldScore: Bool = false
    var homeGold: Int32 = 0
    var awayGold: Int32 = 0
    var hasKillsScore: Bool = false
    var homeKills: Int32 = 0
    var awayKills: Int32 = 0
    var hasWonRounds: Bool = false
    var homeWonRounds: Int32 = 0
    var awayWonRounds: Int32 = 0
    var hasGoals: Bool = false
    var homeGoals: Int32 = 0
    var awayGoals: Int32 = 0
    var favoriteProperties: FavoriteProperties?
    var isVisible: Bool = false
}

extension CSScoreboard {
    static func entity(from: Bb_Mobile_OddinTreeWs_Match.Scoreboard) -> Self {
        var entity = CSScoreboard()
        entity.currentCtTeam = CTTeam(rawValue: from.currentCtTeam)
        entity.currentRound = from.currentRound
        entity.hasDestroyedTowersScore = from.hasHomeDestroyedTowers && from.hasAwayDestroyedTowers
        entity.homeDestroyedTowers = from.homeDestroyedTowers
        entity.awayDestroyedTowers = from.awayDestroyedTowers
        entity.hasDestroyedTurretsScore = from.hasHomeDestroyedTurrets && from.hasAwayDestroyedTurrets
        entity.homeDestroyedTurrets = from.homeDestroyedTurrets
        entity.awayDestroyedTurrets = from.awayDestroyedTurrets
        entity.hasGoldScore = from.hasHomeGold && from.hasAwayGold
        entity.homeGold = from.homeGold
        entity.awayGold = from.awayGold
        entity.hasKillsScore = from.hasHomeKills && from.hasAwayKills
        entity.homeKills = from.homeKills
        entity.awayKills = from.awayKills
        entity.hasWonRounds = from.hasHomeWonRounds && from.hasAwayWonRounds
        entity.homeWonRounds = from.homeWonRounds
        entity.awayWonRounds = from.awayWonRounds
        entity.hasGoals = from.hasHomeGoals && from.hasAwayGoals
        entity.homeGoals = from.homeGoals
        entity.awayGoals = from.awayGoals
        entity.favoriteProperties = FavoriteProperties(rawValue: from.favoriteProperties)
        entity.isVisible = from.isVisible
        return entity
    }
    
    func getGameScore() -> (home: Int32, away: Int32)? {
        switch self.favoriteProperties {
        case .gold: return (homeGold, awayGold)
        case .goals: return (homeGoals, awayGoals)
        case .kills: return (homeKills, awayKills)
        case .rounds: return (homeWonRounds, awayWonRounds)
        case .towers: return (homeDestroyedTowers, awayDestroyedTowers)
        case .turrets: return (homeDestroyedTurrets, awayDestroyedTurrets)
        case .none: return nil
        }
    }
}

extension CSScoreboard {
    enum CTTeam: String, Codable {
        case home = "home"
        case away = "away"
    }
    
    enum FavoriteProperties: String, Codable {
        case gold
        case goals
        case kills
        case rounds
        case towers
        case turrets
    }
}
