//
//  MainPresenter.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import Foundation
final class MainPresenter: MainOutput {
    
    // MARK: - Properties
    private var state = CyberSportMainState()
    private var updaterTimer: Timer?
    private var awaitSetSettingAction: AwaitSetSettingResponseAction?
    var interactor = MainInteractor()
    private var needSwitchPrematchIfLivesEmpty = false
    weak var view: MainViewInput!
    private var didLoaded = false
    private var willAppeared = false
    private var isLostConnect = false
    private var stateAwait: Bool = false
    var isNeedToUpdateStories = false
    var firstLaunch: Bool = true
    var tags = [String]()
    // MARK: - Constructor
   
    public init(view: MainViewInput ) {
        self.view = view
    }
    

    
    func viewDidLoad() {
//        state.sportSettings = interactor.getSettings()
        bindingWs()
        
        if interactor.checkConnected() {
            
            awaitSetSettingAction = .state
            interactor.sendSetSetting(filter: "all")
        } else {
//            interactor.wsStart()
            interactor.wsConnect()
        }
        
        if !didLoaded {
            needSwitchPrematchIfLivesEmpty = true
            didLoaded = true
        }
        getGamblerTags()
    }
    
    func viewWillAppear(animated: Bool) {
        
    }
    
    
    func getGamblerTags() {
        print("TEST START")
        interactor.gamblerTagsRequest { [weak self] response in
            guard let self = self else { return }
            print("TEST START", response)
            let id = self.interactor.getGamblerId()
            var newTags: [String]
            
            switch response {
            case let .success(result):
                newTags = result.gamblerTags
            case let .failure(error):
                newTags = []
                debugPrint(error)
            }
          
            if self.firstLaunch {
//                self.view?.setInAppStories(id: id, tags: newTags)
                self.view?.setTagsStoryAndLoad(tags: newTags)
                self.firstLaunch = newTags.isEmpty ? true : false
            } else if newTags != self.tags || isNeedToUpdateStories {
//                self.view?.updateInAppStories((id: id, tags: newTags))
                self.view?.setTagsStoryAndLoad(tags: newTags)
                isNeedToUpdateStories = false
            }
            self.tags = newTags
        }
    }
    
    
    func onAction(type: String, data: [String: Any]?) {
//        var action: RedirectOption
//        guard let data = data?["data"] as? [String: Any] else { return }
//        guard let tupleTwo = data["tupleTwo"] as? String else { return }
//        
//        let jsonData = tupleTwo.data(using: .utf8)!
//        
//        do {
//            action = try JSONDecoder().decode(RedirectOption.self, from: jsonData)
//        } catch { return }
//        
//        onInAppStoryAction?(action)
    }
    
    
    
    func onDeepLinkAction(deepLink: String) {
//        var action: RedirectOption
//        let jsonData = deepLink.data(using: .utf8)!
//        
//        do {
//            action = try JSONDecoder().decode(RedirectOption.self, from: jsonData)
//        } catch { return }
//        
//        onInAppStoryAction?(action)
    }
   
    
    
    func changeCurrentFilter(_ model: CSFilter) {
        state.currentFilter = model
        state.clearTournaments()
        view?.setSelectedFilter(model)
        awaitSetSettingAction = .sport
        interactor.sendSetSetting(filter: model.getValue())
        
      
    }
    
    
    
    
    func tapTournament(_ tournament: CSTournament) {
        if state.getType() == .live {
            var temp = tournament
            temp.collapsed.toggle()
            if tournament.collapsed {
                state.addUncollapsedLiveTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id)
            } else {
                state.removeUncollapsedLiveTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id)
            }
            guard let updated = state.updatePrematchTournament(temp) else { return }
            view?.updateTournament(model: updated, scroll: false)
        } else {
            if tournament.collapsed {
                interactor.sendUnsubscribeTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id, type: .prematch)
                var temp = tournament
                temp.matches.removeAll()
                temp.collapsed.toggle()

                guard let updated = state.updatePrematchTournament(temp) else { return }
                view?.updateTournament(model: updated, scroll: false)
                state.removeСollapsedPrematchTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id)
            } else {
                interactor.sendSubscribeTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id, type: .prematch)
                state.addСollapsedPrematchTournament(sportId: tournament.info.sportId, tournamentId: tournament.info.id)
            }
        }
    }
    
    func createTimer() {
        if updaterTimer != nil {
            cancelTimer()
        }
        
        updaterTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    func cancelTimer() {
        updaterTimer?.invalidate()
        updaterTimer = nil
    }
    
    @objc func updateTimer() {
        if state.isTournamentsChanges {
            view?.updateTournaments(model: state.getCurrentTournaments())
            state.isTournamentsChanges = false
        }
        if state.isSportsChanges {
            view?.updateSports(model: state.sports)
            state.isSportsChanges = false
        }
    }
    
    func bindingWs() {
        interactor.subscribeNetworkStatus { [weak self] connect in
            guard let self = self else { return }
            if connect, self.isLostConnect {
                self.interactor.wsConnect()
                self.isLostConnect = false
            } else {
                self.isLostConnect = true
            }
        }
        interactor.subscribeAppState { [weak self] state in
            guard let self = self else { return }
            if state == .background {
                self.cancelTimer()
            }
        }
        interactor.subscribeResponseWsConnected { [weak self] success in
            guard let self = self else { return }
            if success {
                self.awaitSetSettingAction = .state
                self.interactor.sendSetSetting(filter: "all")
            }
        }
        interactor.subscribeStateAwait { [weak self] _await in
            guard let self = self else { return }
            if _await { self.stateAwait = true }
        }
        interactor.subscribeStateReady { [weak self] ready in
            guard let self = self else { return }
            if ready {
                self.awaitSetSettingAction = .state
                self.interactor.sendSetSetting(filter: self.state.currentFilter.getValue())
                self.stateAwait = false
            }
        }
        interactor.subscribeResponseSetSetting { [weak self] success in
            guard let self = self else { return }
            if success {
                switch self.awaitSetSettingAction {
                case .state:
                    self.interactor.sendSubscribeState()
                case .sport:
                    if let sportId = self.state.sportId {
                        self.interactor.sendSubscribeSport(id: sportId, type: self.state.getType())
                    }
                case .none:
                    break
                }
                self.awaitSetSettingAction = nil
                self.createTimer()
            }
        }onError: { [weak self] message in
            guard let self = self else { return }
            self.handleError(message)
        }
        
//
//        interactor.subscribeResponseWsConnected { [weak self] success in
//            guard let self = self else { return }
//            if success {
//                self.awaitSetSettingAction = .state
//                self.interactor.sendSetSetting(filter: "all")
//            }
//        }
        
        
        interactor.subscribeResponseState { [weak self] result in
            guard let self = self else { return }
//            self.view?.tournamentsCollection.clear()
            self.view?.hideFilterSkeleton()
            self.view?.hideGameFilterSkeleton()
            let sports = self.handleState(live: result.live, prematch: result.prematch)
            print("sports", sports)
            self.state.sports = sports
            var idToSubscribe: String?
            if let id = self.state.sportId {
                idToSubscribe = id
            } else if let id = sports.first?.id {
                self.state.sportId = id
                idToSubscribe = id
            }
            
            if let id = idToSubscribe {
                self.view?.setSports(model: sports, id: id)
                self.interactor.sendSubscribeSport(id: id, type: self.state.getType())
            }
//            var idToSubscribe: String?
//            if let id = self.state.sportId {
//                idToSubscribe = id
//            } else if let id = sports.first?.id {
//                self.state.sportId = id
//                idToSubscribe = id
//            }
//            if let id = idToSubscribe {
//                self.view?.setSports(model: sports, id: id)
//                self.interactor.sendSubscribeSport(id: id, type: self.state.getType())
//            }
//
//            let (division, subdivision) = self.getAppMetricaInfo()
//            AppMetricaService.shared.sendCybersportPageLoadEvent(division: division, subdivision: subdivision)
            
            
        } onError: { [weak self] message in
            self?.handleError(message)
        }
        let noMatches = NSLocalizedString("NoMatches", comment: "NoMatches Title")
        
        interactor.subscribeResponseSport { [weak self] result in
            guard let self = self else { return }
          
            var tournaments = self.sortTournaments(result.tournaments)
            if tournaments.isEmpty {
                self.view?.setTournamentsPlaceholder(model: noMatches)
            } else {
           
                if self.state.currentFilter.getModel().type == .live {
                    let uncollapsed = self.state.getUncollapsedLiveTournaments(sportId: result.info.id) ?? []
                    (0...tournaments.count - 1).forEach{
                        tournaments[$0].collapsed = !uncollapsed.contains(tournaments[$0].info.id)
                    }
                } else {
                    if let uncollapsed = self.state.getСollapsedPrematchTournaments(sportId: result.info.id), !uncollapsed.isEmpty {
                        for tournamentId in uncollapsed {
                            self.interactor.sendSubscribeTournament(sportId: result.info.id, tournamentId: tournamentId, type: .prematch)
                        }
                    } else {
                        if let first = tournaments.first {
                            self.interactor.sendSubscribeTournament(sportId: first.info.sportId, tournamentId: first.info.id, type: .prematch)
                            self.state.addСollapsedPrematchTournament(sportId: first.info.sportId, tournamentId: first.info.id)
                        }
                    }
                }
                
                self.state.tournaments = tournaments
                let currentTournaments = self.state.getCurrentTournaments()
                
                if currentTournaments.isEmpty {
                    let message: String = noMatches
                    
                    self.view?.setTournamentsPlaceholder(model: message)
                } else {
                    self.view?.setTournaments(model: currentTournaments)
                }
            }
            if self.needSwitchPrematchIfLivesEmpty {
                self.view?.setSelectedFilter(self.state.currentFilter)
            }
            self.needSwitchPrematchIfLivesEmpty = false
        } onError: { [weak self] message in
            guard let self = self else { return }
            if message != "Sport not found" {
                self.handleError(message)
            }
            if self.needSwitchPrematchIfLivesEmpty {
                let allPrematch: CSFilter = .allPrematch
                self.state.currentFilter = allPrematch
                self.view?.setSelectedFilter(allPrematch)
                self.awaitSetSettingAction = .sport
                self.interactor.sendSetSetting(filter: allPrematch.getValue())
                self.needSwitchPrematchIfLivesEmpty = false
            } else {
                self.view?.setTournamentsPlaceholder(model: noMatches)
            }
            
        }
        
        
        interactor.subscribeResponseTournament { [weak self] result in
            guard let self = self, self.state.getType() == .prematch else { return }
            var temp = result
            temp.matches = self.sortMatches(temp.matches)
            temp.collapsed.toggle()
            if let updated = self.state.updatePrematchTournament(temp) {
                self.view?.updateTournament(model: updated, scroll: false)
            }
        } onError: { [weak self] message in
            self?.handleError(message)
        }
        interactor.subscribeUpdateSport { [weak self] action, result in
            guard let self = self else { return }
            switch action {
            case .update:
                self.state.updateSportInfo(result.info)
            case .create:
                self.state.insertSportInfo(result.info)
            case .delete:
                self.state.deleteSportInfo(result.info)
            default:
                self.state.updateSportInfo(result.info)
            }
        } onError: { [weak self] message in
            self?.handleError(message)
        }
        
        
        interactor.subscribeUpdateTournament { [weak self] action, result in
            guard let self = self, self.state.sportId == result.info.sportId else { return }
            switch action {
            case .update:
                self.state.updateTournament(result)
            case .create:
                self.state.insertTournament(result)
            case .delete:
                self.state.deleteTournament(result)
            default:
                self.state.updateTournament(result)
            }
        } onError: { [weak self] message in
            self?.handleError(message)
        }
        
        
        interactor.subscribeUpdateMatch { [weak self] action, result in
            guard let self = self, self.state.sportId == result.sportId, result.type == self.state.getType() else { return }
            switch action {
            case .update:
                self.state.updateMatch(result)
            case .create:
                self.state.insertMatch(result)
            case .delete:
                self.state.deleteMatch(result)
            default:
                self.state.updateMatch(result)
            }
        } onError: { [weak self] message in
            self?.handleError(message)
        }
    }
    
    func sortStakes(_ model: [CSStake]) -> [CSStake] {
        return model.sorted(by: { $0.order < $1.order })
    }
    
    func sortMatches(_ model: [CSMatch]) -> [CSMatch] {
        let result: [CSMatch] = model.map { match in
            var temp = match
            temp.stakes = sortStakes(match.stakes)
            return temp
        }
        
        return result.sorted(by: { $0.startDttm < $1.startDttm })
    }
    
    func sortTournaments(_ model: [CSTournament]) -> [CSTournament] {
        let result: [CSTournament] = model.map { tournament in
            var temp = tournament
            temp.matches = sortMatches(tournament.matches)
            return temp
        }
        
        return result.sorted(by: { left, right -> Bool in
            switch self.state.sportSettings.sort {
            case .popularity: return left.info.order < right.info.order
            case .name: return left.info.name < right.info.name
            case .country: return left.info.order < right.info.order
            }
        })
    }
    
    
    func changeCurrentSport(id: String) {
        if let old = state.sportId {
            interactor.sendUnsubscribeSport(id: old, type: state.getType())
        }
        state.sportId = id
        state.clearTournaments()
        view.setSelectedSport(id, scrollToCenter: false)
        
        let live: CSFilter = .allLive
        state.currentFilter = live
        awaitSetSettingAction = .sport
            needSwitchPrematchIfLivesEmpty = true
        interactor.sendSetSetting(filter: live.getValue())
        
//            needSendClickCybergameEvent = true
    }
    
    func handleState(live: [CSSportInfo], prematch: [CSSportInfo]) -> [CSSportInfo] {
        var sports = [CSSportInfo]()
        var liveSportIds = Set<String>()
        for item in live {
            liveSportIds.insert(item.id)
            var liveItem = item
            liveItem.hasLive = true
            sports.append(liveItem)
        }
        for item in prematch {
            if liveSportIds.contains(item.id) { continue }
            sports.append(item)
        }
        return sports.sorted(by: { $0.order < $1.order })
    }
    
    func handleError(_ message: String) {
        debugPrint("\(message)")
    }
    
    
    
    enum AwaitSetSettingResponseAction {
        case state
        case sport
    }
}


