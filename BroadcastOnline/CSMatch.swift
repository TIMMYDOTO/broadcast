//
//  CSMatch.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSMatch: Codable, Hashable {
    ///enitty
    var id: String = String()
    var order: Int32 = 0
    var type: SportLivePrematch = .prematch
    var active: Bool = false
    var betStop: Bool = false
    var sportId: String = String()
    var tournamentId: String = String()
    var matchStatus: String = String()
    var startDttm: Date = Date()
    var stakesCount: Int32 = 0
    var isScoreboardAvailable: Bool = false
    var scoreboard: CSScoreboard?
    var stream: CSStream?
    var teams: [CSTeam] = []
    var periodScores: [CSPeriodScore] = []
    var stakes: [CSStake] = []
    var favoritePeriodScoreProperties: FavoritePeriodScoreProperties?
    
    ///extra
    var tournamentName: String = String()
}

extension CSMatch {
    static func entity(from: Bb_Mobile_OddinTreeWs_Match) -> Self {
        var entity = CSMatch()
        entity.id = from.id
        entity.order = from.order
        entity.type = SportLivePrematch(rawValue: from.type) ?? .prematch
        entity.active = from.active
        entity.betStop = (from.betStop && !from.active)
        entity.sportId = from.sportID
        entity.tournamentId = from.tournamentID
        entity.matchStatus = from.matchStatus
        entity.startDttm = from.startDttm.getDateFromString(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") ?? Date()
        entity.stakesCount = from.stakesCount
        entity.isScoreboardAvailable = from.isScoreboardAvailable
        entity.scoreboard = from.hasScoreboard ? CSScoreboard.entity(from: from.scoreboard) : nil
        entity.stream = from.hasStream ? CSStream.entity(from: from.stream) : nil
        entity.teams = from.teams.map { CSTeam.entity(from: $0) }
        entity.periodScores = from.periodScores.map { CSPeriodScore.entity(from: $0) }
        entity.stakes = from.stakes.map { CSStake.entity(from: $0) }
        entity.favoritePeriodScoreProperties = FavoritePeriodScoreProperties(rawValue: from.favoritePeriodScoreProperties)
        return entity
    }
}

enum FavoritePeriodScoreProperties: String, Codable, Hashable {
    case score
    case goals
    case kills
    case rounds
}
