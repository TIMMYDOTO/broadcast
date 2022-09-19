//
//  Sport.swift
//  BetBoom
//
//  Created by Козлов Виталий Алексеевич on 04.02.2021.
//

import Foundation



struct Stake: Codable, Hashable {
    var id: Int32 = 0
    var matchId: Int32 = 0
    var name = ""
    var order: Int32 = 0
    var shortName = ""
    var argument: Double = 0.0
    var hasArgument = false
    var stakeTypeId = 0
    var stakeType = ""
    var stakeTypeOrder: Int32 = 0
    var stakeTypeView = ""
    var typeGroupId: Int32 = 0
    var typeGroupName: String = ""
    var typeGroupOrder: Int32 = 0
    var isAllowCashout = false
    var factor: Double = 0
    var isActive = false
    var stakeStatus = ""
    var stakeColor: StakeColor?
    var isLive = false
    var isForLiveTV = false
    var oldFactor: Double?
    var startFactor: Double = 0
    var teams = [Team]()
    var tournamentName: String = ""
    var sportID: Int32 = 0
    var startDttm = String()
 
    var isUnite = false
    var isShowSign = false
    var code: Int32 = 0

    var periodID: Int32 = 0
    var periodName = ""
    
    init(_ stake: Bb_Mobile_SportTreeWs_Stake) {
        self.id = stake.id
        self.matchId = stake.matchID
        self.name = stake.name
        self.order = stake.order
        self.shortName = stake.shortName
        self.argument = stake.argument
        self.hasArgument = stake.hasArgument
        self.stakeTypeId = Int(stake.stakeTypeID)
        self.stakeType = stake.stakeType
        self.stakeTypeOrder = stake.stakeTypeOrder
        self.stakeTypeView = stake.stakeTypeView
        self.isLive = stake.isLive
        self.typeGroupId = stake.typeGroupID
        self.typeGroupName = stake.typeGroupName
        self.typeGroupOrder = stake.typeGroupOrder
        self.isAllowCashout = stake.allowCashout
        self.factor = stake.factor
        self.isActive = stake.active
        self.isForLiveTV = stake.isForLiveTv
        self.isShowSign = stake.isShowSign
        self.code = stake.code
        self.periodName = stake.periodName
    }
    
    init(name: String, factor: Double, type: Int = 0) {
        self.name = name
        self.factor = factor
        self.stakeTypeId = type
    }

    init() {
        
    }
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Stake, rhs: Stake) -> Bool {
        return lhs.id == rhs.id
    }
}

enum StakeColor: String, Codable {

    case green = "green"
    case red = "red"
    
}


struct Team: Codable {
    var isHome = false
    var name = ""
    var score: Int32 = 0
    var image = ""
    var type: ImageType = .none
    var isServing = false
    var gameScore: Int32 = 0
    
    init() { }

    init(_ team: Bb_Mobile_SportTreeWs_Match.Team) {
        self.name = team.name
        self.isHome = team.home
        self.score = team.score
        self.isServing = team.isServing
        self.gameScore = team.gameScore
   
    }
    

    
    
    init(name: String) {
        self.name = name
    }
}

extension Team {
    enum ImageType: String, Codable {
        case human = "human"
        case logo = "logo"
        case none = ""
    }
}


struct Match: Codable, Hashable {
    var id: Int32 = 0
    var parentId: Int32 = 0
    var order: Int32 = 0
    var type: MatchType = .unknown
    var name = ""
    var active: Bool = false
    var betStop: Bool = false
    var sportId: Int32 = 0
    var sportGid = ""
    var championshipId: Int32 = 0
    var championshipGid = ""
    var tournamentId: Int32 = 0
    var tournamentGid = ""
    var matchTime: Int32 = 0
    var matchStatus = ""
    var startDttm = Date()
    var score = ""
    var stakesCount: Int32 = 0
    var hasLiveTv = false
    var hasLiveInfo = false
    var unite = false
    var teams = [Team]()
    var stakes = [Stake]()
  
    var periodID: Int32 = 0
    

    var groupedStakes = [[Stake]]()
    var oldStakes = [Stake]()
    var action: SportEventAction?
    var comment = ""
    var tournament = Tournament()
    
    var currentGamePart: Int32 = 0
    var playersCounts: String = ""


    var isSelected = false
    var sportName = ""
    
    init(_ data: Bb_Mobile_SportTreeWs_Match) {
        self.id = data.id
        self.parentId = data.parentID
        self.order = data.order
        self.type = MatchType(rawValue: data.type) ?? .unknown
        self.name = data.name
        self.active = data.active
        self.betStop = data.betStop
        self.sportId = data.sportID
        self.sportGid = data.sportGid
        self.championshipId = data.championshipID
        self.championshipGid = data.championshipGid
        self.tournamentId = data.tournamentID
        self.tournamentGid = data.tournamentGid
        self.matchTime = data.matchTime
        self.matchStatus = data.matchStatus
        self.startDttm = data.startDttm.getDateFromString(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") ?? Date()
        self.score = data.score
        self.stakesCount = data.stakesCount
        self.hasLiveTv = data.hasLiveTv_p
        self.hasLiveInfo = data.hasLiveInfo_p
        self.unite = data.unite
        self.comment = data.comment
        data.teams.forEach { (teamData) in
            let team = Team(teamData)
            self.teams.append(team)
        }
        
        data.stakes.forEach { stakeData in
            let stake = Stake(stakeData)
            self.stakes.append(stake)
        }
        
        self.periodID = data.periodID
        self.currentGamePart = data.currentGamePart
        self.playersCounts = data.playersCounts
        if !self.playersCounts.isEmpty {
            print("playersCounts", self.playersCounts)
        }
    }
    

    
    init() {
        
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct SportDetails {
    var grouppedStakes = [[Stake]]()
    var unite: Bool!
    var typeGroupId: Int32!
    var typeGroupName: String!
    var typeGroupOrder: Int32!
    var isSelected = false
    var matchId: Int32!
    var match: Match!
    var isMainMatch = false
    var isAllTab = false
//    var score = ""
    
}



struct Tournament: Codable {
    var code: Int32 = 200
    var id: Int32 = 0
    var gid = ""
    var name = ""
    var order: Int32 = 0
    var sportId: Int32 = 0
    var sportGid = ""
    var championshipId: Int32 = 0
    var championshipGid = ""
    var championshipName = ""
    var championshipOrder: Int32 = 0
    var matchesCount: Int32 = 0
    var hasLiveTvMatch: Bool = false
    
    var sportName = ""
    var isForFavorites: Bool = false
    var action: SportEventAction?
    var collapsed: Bool = true
    var matches = [Match]()
    
    init(_ tournament: Bb_Mobile_SportTreeWs_Tournament) {
        self.id = tournament.info.id
        self.gid = tournament.info.gid
        self.name = tournament.info.name
        self.order = tournament.info.order
        self.sportId = tournament.info.sportID
        self.sportGid = tournament.info.sportGid
        self.hasLiveTvMatch = tournament.info.hasLiveTvMatch_p
        self.championshipId = tournament.info.championshipID
        self.championshipGid = tournament.info.championshipGid
        self.championshipName = tournament.info.championshipName
        self.championshipOrder = tournament.info.championshipOrder
        self.collapsed = false
        self.matchesCount = tournament.info.matchesCount
        tournament.matches.forEach { matchData in
            var match = Match(matchData)
            match.tournament.name = tournament.info.name
            matches.append(match)
        }
    }
    init() {
        
    }
}

struct Sport {
    var id: Int32 = 0
    var gid = ""
    var name = ""
    var order: Int32 = 0
    var tournaments = [Tournament]()
    var type: SportLivePrematch?
    var hasLiveTvMatch: Bool = false
    var hasLiveInfoMatch: Bool = false
    
    var hasLive: Bool = false
    var action: SportEventAction?
    

    init(_ sport: Bb_Mobile_SportTreeWs_Sport, type: String) {
        self.id = sport.info.id
        self.gid = sport.info.gid
        self.name = sport.info.name
        self.order = sport.info.order
        self.type = SportLivePrematch(rawValue: type)
        self.hasLiveInfoMatch = sport.info.hasLiveInfoMatch_p
        self.hasLiveTvMatch = sport.info.hasLiveTvMatch_p
        
        sport.tournaments.forEach { tournamentData in
            let tournament = Tournament(tournamentData)
            self.tournaments.append(tournament)
        }
        tournaments = tournaments.sorted(by: {$0.order < $1.order})
    }
}

struct State {
    var code: Int32 = 0
    var status = ""
    var sportsLive = [Sport]()
    var sportsPrematch = [Sport]()
    var needToUpdateTableView = ElementToUpdate.state // to do ???
    
    init(_ state: Bb_Mobile_SportTreeWs_SubscribeStateResponse) {
        self.code = state.code
        self.status = state.status
        state.live.forEach { sportData in
            let sportLive = Sport(sportData, type: "live")
            sportsLive.append(sportLive)
        }
        state.prematch.forEach { sportData in
            let sportPrematch = Sport(sportData, type: "prematch")
            sportsPrematch.append(sportPrematch)
        }
    }
}





struct MatchToUpdate {
    var match: Match?
    var section = 0
    var row = 0
    var updateType = UpdateType.update
}

struct Bet: Codable {
    var match = Match()
    var stake = Stake()
    
    var csMatch = CSMatch()
    var csStake = CSStake()
    
    var isBlock = false
    var isActive = false
    //var selectedStake = [Int32: Set<Int32>]()
    var amount: Double?
    var betCorrelationID = ""
    var error = ""
    var compabilityError = ""
    var isCS = false
    var isSubscribed = false

    init(_ match: Match, _ stake: Stake) {
        self.match = match
        self.stake = stake
        self.betCorrelationID = "\(match.id)\(stake.id)"
        self.isCS = false
    }
    
    init(_ csMatch: CSMatch, _ csStake: CSStake) {
        self.csMatch = csMatch
        self.csStake = csStake
        self.betCorrelationID = "\(csMatch.id)\(csStake.id)"
        self.isCS = true
    }
    
    
    
    init() {}
}

enum UpdateType: String {
    case update = "update_info"
    case create = "create"
    case delete = "delete"
    case updateFullMatch = "update"
}

enum ElementToUpdate {
    case state
    case championship
    case tournament
    case none
}


enum MatchType: String, Codable {
    case prematch = "prematch"
    case live = "live"
    case unknown = "unknown"
}
