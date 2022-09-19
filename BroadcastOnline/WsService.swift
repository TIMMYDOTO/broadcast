////
////  WsService.swift
////  BetBoom
////
////  Created by Козлов Виталий Алексеевич on 07.10.2020.
////  Copyright © 2020 BetBoom. All rights reserved.
////

import Foundation
import Starscream
import RxSwift

final class WsService: SessionServiceDependency, WebSocketDelegate, WsServiceInterface {
    
    
    var sportId: Int32 = 1
    
    var isStateLoaded = false
    private var socket: WebSocket!
    private var url: String {
       // return "wss://bboncyp-oddin.bb-online-stage.com/api/sport_tree_ws/v1"
        return AppDataStore.shared.appConfig.sportTreeWsUrlProd
//        return "wss://bboncyp-digitaincyp.bb-online-stage.com/api/sport_tree_ws/v1"
    }
    var state = ConnectionState.disconnected
    private var observers = [(AnyObject, (State) -> Void)]()
    fileprivate let subject = PublishSubject<Event>()
    let appState = PublishSubject<AppState>()
    private var observerForeground: NSObjectProtocol?
    private var observerBackground: NSObjectProtocol?
    
    var connected: Observable<Bool> {
        return subject
            .filter {
                
                switch $0 {
                case .connected, .disconnected:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .connected:
                    return true
                default:
                    return false
                }
        }
    }
    
    fileprivate enum InitSportState {
        case connected
        case disconnected(Error?)
        case response(State)
    }
    
    fileprivate enum SportEnum {
        case connected
        case disconnected(Error?)
        case response(Sport)
    }
    
    fileprivate enum TopSportsEnum {
        case connected
        case disconnected(Error?)
        case response([Sport])
    }
    
    fileprivate enum TopSportEnum {
        case connected
        case disconnected(Error?)
        case response(Sport)
    }
    
    fileprivate enum Event {
        case connected
        case disconnected(Error?)
        case response(Bb_Mobile_Ws_BepokeEventsSportsResponse)
    }
    
    fileprivate enum MatchEnum {
        case connected
        case disconnected(Error?)
        case response(Match)
    }
    
    fileprivate enum TopMatchEnum {
        case connected
        case disconnected(Error?)
        case response(Match)
    }
    
    fileprivate enum TournamentEnum {
        case connected
        case disconnected(Error?)
        case response(Tournament)
    }
    
    fileprivate enum StakeEnum {
        case connected
        case disconnected(Error?)
        case response(Stake)
    }
    
    fileprivate enum FullMatchEnum {
        case connected
        case disconnected(Error?)
        case response(FullMatch)
    }
    
    fileprivate enum FullMatchResponseEnum {
        case connected
        case disconnected(Error?)
        case response(FullMatchUpdateResponse)
    }
    
    fileprivate enum DeletedMatchEnum {
        case connected
        case disconnected(Error?)
        case response(String)
    }

    private var disposeBag = DisposeBag()
    fileprivate let subjectInitSportState = PublishSubject<InitSportState>()
    fileprivate let subjectSport = PublishSubject<SportEnum>()
    fileprivate let subjectMatch = PublishSubject<MatchEnum>()
    fileprivate let subjectTopMatch = PublishSubject<TopMatchEnum>()
    fileprivate let subjectTopSports = PublishSubject<TopSportsEnum>()
    fileprivate let subjectTopSport = PublishSubject<TopSportEnum>()
    fileprivate let subjectTournament = PublishSubject<TournamentEnum>()
    fileprivate let subjectStake = PublishSubject<StakeEnum>()
    fileprivate let subjectFullMatch = PublishSubject<FullMatchEnum>()
    fileprivate let subjectDeletedMatch = PublishSubject<DeletedMatchEnum>()
    fileprivate let subjectFullMatchUpdateResponse = PublishSubject<FullMatchResponseEnum>()
    
   // fileprivate let subject = PublishSubject<Event>()
    
    var deletedMatch: Observable<String> {
        return subjectDeletedMatch
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return ""
                }
            }
    }
    
    var topSports: Observable<[Sport]?> {
        return subjectTopSports
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return [Sport]()
                }
            }
    }
    
    var stake: Observable<Stake?> {
        return subjectStake
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Stake(Bb_Mobile_SportTreeWs_Stake())
                }
            }
    }
    
    var initSportState: Observable<State?> {
        return subjectInitSportState
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return State(Bb_Mobile_SportTreeWs_SubscribeStateResponse())
                }
            }
    }
    
    var sport: Observable<Sport?> {
        return subjectSport
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Sport(Bb_Mobile_SportTreeWs_Sport(), type: "")
                }
            }
    }
    
    var topSport: Observable<Sport?> {
        return subjectTopSport
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Sport(Bb_Mobile_SportTreeWs_Sport(), type: "")
                }
            }
    }

    var match: Observable<Match?> {
        return subjectMatch
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Match(Bb_Mobile_SportTreeWs_Match())
                }
            }
    }
    
    var topMatch: Observable<Match?> {
        return subjectTopMatch
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Match(Bb_Mobile_SportTreeWs_Match())
                }
            }
    }
    
    var tournament: Observable<Tournament?> {
        return subjectTournament
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return Tournament(Bb_Mobile_SportTreeWs_Tournament())
                }
            }
    }
    
    var fullMatch: Observable<FullMatch?> {
        return subjectFullMatch
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return FullMatch(Bb_Mobile_SportTreeWs_SubscribeFullMatchResponse())
                }
            }
    }
    
    var fullMatchUpdateReponse: Observable<FullMatchUpdateResponse?> {
        return subjectFullMatchUpdateResponse
            .filter {
                switch $0 {
                case .response:
                    return true
                default:
                    return false
                }
            }
            .map {
                switch $0 {
                case .response(let response):
                    return response
                default:
                    return FullMatchUpdateResponse(Bb_Mobile_SportTreeWs_FullMatchResponse())
                }
            }
    }
    
    var stateReady = PublishSubject<Bool>()

    init(url: String) {
        //self.url = url
        observerForeground = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            connect()
            
        }
        observerBackground = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            disconnect()
        }
    }
    var sportState = State(Bb_Mobile_SportTreeWs_SubscribeStateResponse())
    
    func connect() {
        print("CONNECT")
        state = .connecting
        guard let url2 = URL(string: url) else { return }
        var request = URLRequest(url: url2)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self
        appState.onNext(.foreground)
        socket.connect()
    }
    
    func disconnect() {
        if socket != nil {
            socket.disconnect()
            appState.onNext(.background)
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            state = .connected
            subject.onNext(.connected)
            print("websocket is connected: \(headers)")
//            setSettings(nil)
        case .disconnected(let reason, let code):
            state = .disconnected
            subject.onNext(.disconnected(nil))
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            parseRequest(data: data) {[weak self] result in
                
                guard let self = self else {return}
                self.checkResponse(result)
            }
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            state = .disconnected
           // subject.onNext(.disconnected(nil))
        case .error(let error):
            state = .disconnected
            handleError(error)
            connect()
        }
    }
  
    private func send(_ data: Bb_Mobile_SportTreeWs_MainRequest) {
            let dataToSend = try! data.serializedData()
        
        guard let socket = socket else {return}
            socket.write(data: dataToSend)
    }
    
    private func parseRequest(data: Data, _ completion: @escaping (Bb_Mobile_SportTreeWs_MainResponse) -> ()) {
        if let response = try? Bb_Mobile_SportTreeWs_MainResponse(serializedData: data) {
            completion(response)
        }
    }
    
    private func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func setSettings (_ timeFilter: String?) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        var setSettingsRequest = Bb_Mobile_SportTreeWs_SetSettingsRequest()
        setSettingsRequest.uid = "13241523656"
        setSettingsRequest.isDisableSportsTimeFilter = true
        if let time = timeFilter {
            print (time)
            setSettingsRequest.timeFilter = time
        } else {
            setSettingsRequest.timeFilter = "all"
        }
        request.setSettings = setSettingsRequest
        send(request)
    }
    
    func getState() {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        var getStateRequest = Bb_Mobile_SportTreeWs_SubscribeStateRequest()
        getStateRequest.uid = "13241523656"
        request.subscribeState = getStateRequest
        send(request)
    }
    
    func sendSubscribe(sport: Bb_Mobile_SportTreeWs_SubscribeSportRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeSport = sport
        sportId = sport.sportID
        send(request)
    }
    
    func sendSubscribe(fullMatch: Bb_Mobile_SportTreeWs_SubscribeFullMatchRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeFullMatch = fullMatch

        send(request)
    }
    
    func sendSubscribe(match: Bb_Mobile_SportTreeWs_SubscribeMatchRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeMatch = match
        
        send(request)
    }
    
    func sendUnsubscribe(match: Bb_Mobile_SportTreeWs_UnsubscribeMatchRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeMatch = match
        
        send(request)
    }
    
    func sendSubscribe(tournament: Bb_Mobile_SportTreeWs_SubscribeTournamentRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeTournament = tournament
        send(request)
    }
    
    func sendSubscribe(fullTournament: Bb_Mobile_SportTreeWs_SubscribeFullTournamentRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeFullTournament = fullTournament
        send(request)
    }
    
    func sendUnsubscribe(fullTournament: Bb_Mobile_SportTreeWs_UnsubscribeFullTournamentRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeFullTournament = fullTournament
        send(request)
    }
    
    
    func sendUnsubscribe(sport: Bb_Mobile_SportTreeWs_UnsubscribeSportRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeSport = sport
        send(request)
    }
    
    func sendSubscribe(stake: Bb_Mobile_SportTreeWs_SubscribeStakeRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeStake = stake
        //request.subscribeStake.uid = "1237814"
        print("Request \(request)")
        send(request)
    }
    
    func sendUnsubscribe(stake: Bb_Mobile_SportTreeWs_UnsubscribeStakeRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeStake = stake
        print("Request \(request)")
        send(request)
    }
    
    func sendUnsubscribe(fullMatch: Bb_Mobile_SportTreeWs_UnsubscribeFullMatchRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeFullMatch = fullMatch
        
        print("Request \(request)")
        send(request)
    }

    
    func sendUnsubscribe(tournament: Bb_Mobile_SportTreeWs_UnsubscribeTournamentRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeTournament = tournament
        send(request)
        guard let sportToUpdate = sportState.sportsPrematch.firstIndex(where: {$0.id == tournament.sportID}) else {return}
        let sportIndex = Int(sportToUpdate)

        guard let tournamentToUpdate = sportState.sportsPrematch[sportIndex].tournaments.firstIndex(where: {$0.id == tournament.tournamentID}) else {return}
        let tournamentIndex = Int(tournamentToUpdate)
        
        sportState.sportsPrematch[sportIndex].tournaments[tournamentIndex].matches.removeAll()
        sportState.needToUpdateTableView = .state
        self.subjectInitSportState.onNext(.response(self.sportState))
        
    }
    
    func sendUnsubscribeTop() {

        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.unsubscribeTop = Bb_Mobile_SportTreeWs_UnsubscribeTopRequest()

        send(request)
    }
    
    func sendSubscribe(topSports: Bb_Mobile_SportTreeWs_SubscribeTopRequest) {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        request.subscribeTop = topSports
        
        send(request)
    }
    
    func sendUnsubscribeAll() {
        var request = Bb_Mobile_SportTreeWs_MainRequest()
        var unsubscribeRequest = Bb_Mobile_SportTreeWs_UnsubscribeRequest()
        unsubscribeRequest.uid = "13241523656"
        request.unsubscribe = unsubscribeRequest
        send(request)
        isStateLoaded = false
    }
    
    
    private func checkResponse(_ result: Bb_Mobile_SportTreeWs_MainResponse) {
        
        if result.type == .stateReady(result.stateReady){
            stateReady.onNext(true)
            print("stateReady")
            return
        }
        if result.type == .some(.stateAwait(.init())){
            stateReady.onNext(false)
            print("stateAwait")
            return
        }
        
        if result.setSettings.code == 200 {
            self.getState()
            print("SetSettings")
            return
        }
        
        if result.subscribeState.code == 200 {
            let state = State(result.subscribeState)
            
            self.subjectInitSportState.onNext(.response(state))
            return
        }
        
        if result.subscribeSport.code == 200 {
            var sportResult = Sport(result.subscribeSport.sport, type: result.subscribeSport.type)
            sportResult.action = .update
            
            if result.subscribeSport.type == "top" {
                self.subjectTopSport.onNext(.response(sportResult))
            } else {
                self.subjectSport.onNext(.response(sportResult))
            }
            return
        }
        
        if
            result.subscribeSport.code == 400,
            result.subscribeSport.error.message == "Sport not found",
            let id = Int32(result.subscribeSport.uid)
        {
            var sportResult = Sport(result.subscribeSport.sport, type: result.subscribeSport.type)
            sportResult.id = id
            sportResult.action = .update
            
            if result.subscribeSport.type == "top" {
//                self.subjectTopSport.onNext(.response(sportResult))
            } else {
                self.subjectSport.onNext(.response(sportResult))
            }
        }
        
        if result.subscribeTop.code == 200 {
            var sportResult = [Sport]()
            result.subscribeTop.top.forEach { sport in
                sportResult.append(Sport(sport, type: "top"))
            }
            self.subjectTopSports.onNext(.response(sportResult))
            return
        }
        
        if result.subscribeTournament.code == 200 {
            

            var tournament = Tournament(result.subscribeTournament.tournament)
            tournament.action = .update
            
            self.subjectTournament.onNext(.response(tournament))
            return
        }
        
        // Изменение списка спортов
        if result.sport.code == 200 {
            var sportResult = Sport(result.sport.sport, type: result.sport.type)
            
            sportResult.action = SportEventAction(rawValue: result.sport.action)
            self.subjectSport.onNext(.response(sportResult))
            return
        }

        if result.tournament.code == 200 {
            
            var tournament = Tournament(result.tournament.tournament)
            tournament.action = SportEventAction(rawValue: result.tournament.action)
            
            self.subjectTournament.onNext(.response(tournament))
            return
        }
        if result.subscribeFullMatch.code == 200 {
            
            let fullMatch = FullMatch(result.subscribeFullMatch)
            self.subjectFullMatch.onNext(.response(fullMatch))
            return
        }
    
        if result.subscribeFullMatch.code == 400 {

            let fullMatch = FullMatch(result.subscribeFullMatch)
            self.subjectFullMatch.onNext(.response(fullMatch))
            return
        }
        
        if result.subscribeMatch.code == 200 {
            
            var matchData = Match(result.subscribeMatch.match)
            matchData.tournament = Tournament(result.subscribeMatch.tournament)
            matchData.sportName = result.subscribeMatch.sport.info.name
            self.subjectMatch.onNext(.response(matchData))
            return
        }
        if result.fullMatch.code == 200 {
            
            let fullMatchUpdateResponse = FullMatchUpdateResponse(result.fullMatch)
            
            self.subjectFullMatchUpdateResponse.onNext(.response(fullMatchUpdateResponse))
            return
        }
        
        if result.subscribeFullTournament.code == 200 {
            var fullTournament = Tournament(result.subscribeFullTournament.live.tournament)
            let prematchTournament = Tournament(result.subscribeFullTournament.prematch.tournament)
            fullTournament.matches.append(contentsOf: prematchTournament.matches)
            
            fullTournament.isForFavorites = true
            fullTournament.action = .create
            let sportName: String
            if !result.subscribeFullTournament.live.sport.info.name.isEmpty {
                fullTournament.sportId = result.subscribeFullTournament.live.sport.info.id
                sportName = result.subscribeFullTournament.live.sport.info.name
            } else {
                fullTournament.sportId = result.subscribeFullTournament.prematch.sport.info.id
                sportName = result.subscribeFullTournament.prematch.sport.info.name
            }
            if result.subscribeFullTournament.live.tournament.info.id != 0 {
                fullTournament.id = result.subscribeFullTournament.live.tournament.info.id
                fullTournament.name = result.subscribeFullTournament.live.tournament.info.name
            } else {
                fullTournament.id = result.subscribeFullTournament.prematch.tournament.info.id
                fullTournament.name = result.subscribeFullTournament.prematch.tournament.info.name
            }
            fullTournament.sportName = sportName
    
            self.subjectTournament.onNext(.response(fullTournament))
            return
        }
            
            if result.match.code == 200{
                var matchData = Match(result.match.match)
                matchData.tournament = Tournament(result.tournament.tournament)
                
                matchData.action = SportEventAction(rawValue: result.match.action)
                switch result.match.type {
                case "top":
                    self.subjectTopMatch.onNext(.response(matchData))
                default:
                    
                    self.subjectMatch.onNext(.response(matchData))
                }
                return
            }
            
            if result.stake.code == 200 {
                let stake = Stake(result.stake.stake)
                
                self.subjectStake.onNext(.response(stake))
                return
            }
            
            if result.subscribeStake.code == 200 {
                
                let stake = Stake(result.subscribeStake.stake)
                self.subjectStake.onNext(.response(stake))
                return
            }
        
        if result.subscribeStake.code == 400 {
          
            self.subjectDeletedMatch.onNext(.response(result.subscribeStake.uid))
            return
        }
        
    }
    
    deinit {
        if let observer = observerForeground {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = observerBackground {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}


enum SportEventAction: String, Codable {
    case update = "update"
    case create = "create"
    case delete = "delete"
}

enum SportLivePrematch: String, Codable {
    case live = "live"
    case prematch = "prematch"
}
