//
//  CyberSportMainState.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct SportSettings: Codable {
    var oneClick: Int = 100
    var rememberSum: Bool = false
    var sort: Sort = .popularity
    var agreeChangingCoef: Bool = false
    var changingCoef: ChangingCoefSetting = .disable
}
enum Sort: String, Codable {
    case popularity = "Популярность события"
    case name = "Название события"
    case country = "Страна"
}
enum ChangingCoefSetting: Codable {
    case disable
    case decrease
    case increase
    case all
    
    func getTitle() -> String {
        switch self {
        case .disable: return "Не согласен"
        case .decrease: return "Понижение"
        case .increase: return "Повышение"
        case .all: return "Все изменения"
        }
    }
    
    func getNWData() -> String {
        switch self {
        case .disable: return "none"
        case .decrease: return "smaller"
        case .increase: return "higher"
        case .all: return "all"
        }
    }
}

class CyberSportMainState {
    
    var sportSettings = SportSettings()
    
    /// current sportId
    var sportId: String?
    /// current filter
    var currentFilter: CSFilter = .allLive
    
    ///current sports info
    var sports = [CSSportInfo]()
    /// current tournaments
    var tournaments = [CSTournament]()
    
    /// changes sports flag
    var isSportsChanges = false
    /// changes tournaments/matches flag
    var isTournamentsChanges = false
    
    
    /// uncollapsedTournaments
    /// live турниры по умолчанию развернутые, поэтому запоминаем свернутые
    private var uncollapsedLiveTournaments: [String: Set<String>] = [:]
    /// prematch турниры по умолчанию свернутые, поэтому запоминаем развернутые
    private var collapsedPrematchTournaments: [String: Set<String>] = [:]
    ///
    
    // MARK: - Methods
    func getType() -> SportLivePrematch {
        return currentFilter == .allLive ? .live : .prematch
    }
    
    func getCurrentTournaments() -> [CSTournament] {
        return tournaments
    }
    
    func findTournament(by id: String) -> CSTournament? {
        if let first = tournaments.first(where: { id == $0.info.id }) {
            return first
        } else { return nil }
    }
    
    /// sports info
    func updateSportInfo(_ info: CSSportInfo) {
        guard let index = sports.firstIndex(where: { $0.id == info.id }) else {
            insertSportInfo(info)
            return
        }
        sports[index] = info
        isSportsChanges = true
    }
    
    func insertSportInfo(_ info: CSSportInfo) {
        if let _ = sports.firstIndex(where: { $0.id == info.id }) { return }
        let indexToInsert: Int
        if let index = sports.firstIndex(where: { info.order < $0.order }) {
            indexToInsert = index
        } else { indexToInsert = sports.count }
        sports.insert(info, at: indexToInsert)
        isSportsChanges = true
    }
    
    func deleteSportInfo(_ info: CSSportInfo) {
        guard let index = sports.firstIndex(where: { $0.id == info.id }) else { return }
        sports.remove(at: index)
        isSportsChanges = true
    }
    /// sports info end
    
    /// tournaments
    func updatePrematchTournament(_ tournament: CSTournament) -> CSTournament? {
        guard let index = tournaments.firstIndex(where: { $0.info.id == tournament.info.id }) else { return nil }
        tournaments[index] = tournament
        
        return tournament
    }
    
    func updateTournament(_ tournament: CSTournament) {
        guard let index = tournaments.firstIndex(where: { $0.info.id == tournament.info.id }) else { return }
        tournaments[index].info = tournament.info
        isTournamentsChanges = true
    }
    
    func insertTournament(_ tournament: CSTournament) {
        let indexToInsert: Int
        if let index = tournaments.firstIndex(where: {
            switch self.sportSettings.sort {
            case .popularity:
                return tournament.info.order < $0.info.order
            case .name:
                return tournament.info.name < $0.info.name
            default:
                return tournament.info.order < $0.info.order
            }
        }) {
            indexToInsert = index
        } else { indexToInsert = tournaments.count }
        
        tournaments.insert(tournament, at: indexToInsert)
        isTournamentsChanges = true
    }
    
    func deleteTournament(_ tournament: CSTournament) {
        guard let index = tournaments.firstIndex(where: { $0.info.id == tournament.info.id }) else { return }
        tournaments.remove(at: index)
        isTournamentsChanges = true
    }
    
    func clearTournaments() {
        tournaments.removeAll()
        isTournamentsChanges = false
    }
    /// tournaments end
    
    /// matches
    func updateMatch(_ match: CSMatch) {
        guard
            let tournamentIndex = tournaments.firstIndex(where: { match.tournamentId == $0.info.id }),
            let matchIndex = tournaments[tournamentIndex].matches.firstIndex(where: { match.id == $0.id })
        else {
            insertMatch(match)
            return
        }
        
        tournaments[tournamentIndex].matches[matchIndex] = match
        isTournamentsChanges = true
    }
    
    func insertMatch(_ match: CSMatch) {
        guard let tournamentIndex = tournaments.firstIndex(where: { match.tournamentId == $0.info.id }) else { return }
        
        let indexToInsert: Int
        if let index = tournaments[tournamentIndex].matches.firstIndex(where: { match.order < $0.order }) {
            indexToInsert = index
        } else { indexToInsert = tournaments[tournamentIndex].matches.count }
        
        tournaments[tournamentIndex].matches.insert(match, at: indexToInsert)
        isTournamentsChanges = true
    }
    
    func deleteMatch(_ match: CSMatch) {
        guard
            let tournamentIndex = tournaments.firstIndex(where: { match.tournamentId == $0.info.id }),
            let indexToDelete = tournaments[tournamentIndex].matches.firstIndex(where: { match.id == $0.id })
        else { return }
        
        tournaments[tournamentIndex].matches.remove(at: indexToDelete)
        isTournamentsChanges = true
    }
    /// matches end
    
    /// uncollapsed tournaments
    func addUncollapsedLiveTournament(sportId: String, tournamentId: String) {
        if uncollapsedLiveTournaments[sportId] == nil {
            uncollapsedLiveTournaments[sportId] = [tournamentId]
        } else {
            uncollapsedLiveTournaments[sportId]?.insert(tournamentId)
        }
    }
    
    func addСollapsedPrematchTournament(sportId: String, tournamentId: String) {
        if collapsedPrematchTournaments[sportId] == nil {
            collapsedPrematchTournaments[sportId] = [tournamentId]
        } else {
            collapsedPrematchTournaments[sportId]?.insert(tournamentId)
        }
    }
    
    func removeUncollapsedLiveTournament(sportId: String, tournamentId: String) {
        uncollapsedLiveTournaments[sportId]?.remove(tournamentId)
    }
    
    func removeСollapsedPrematchTournament(sportId: String, tournamentId: String) {
        collapsedPrematchTournaments[sportId]?.remove(tournamentId)
    }
    
    func getUncollapsedLiveTournaments(sportId: String) -> Set<String>? {
        return uncollapsedLiveTournaments[sportId]
    }
    
    func getСollapsedPrematchTournaments(sportId: String) -> Set<String>? {
        return collapsedPrematchTournaments[sportId]
    }
    /// uncollapsed tournaments end
}
