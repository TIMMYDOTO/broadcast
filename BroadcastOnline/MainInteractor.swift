//
//  MainInteractor.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import Foundation
import RxSwift
import Alamofire

final class MainInteractor: CyberOdinWsServiceDependency, ConnectManagerDependency, ApiServiceDependency, SessionServiceDependency{
    
    let disposeBag = DisposeBag()
    func checkConnected() -> Bool { cyberSportWs.checkConnected() }
    
    func subscribeStateReady(onNext: @escaping (Bool) -> Void) {
        cyberSportWs.subjects.stateReady
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
    
    func subscribeStateAwait(onNext: @escaping (Bool) -> Void) {
        cyberSportWs.subjects.stateAwait
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
    
    func subscribeAppState(onNext: @escaping (AppActiveState) -> Void) {
        cyberSportWs.subjects.appState
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
    
    func subscribeNetworkStatus(_ onNext: @escaping (Bool) -> Void) {
        connectManager.connect
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
    
    func sendUnsubscribeTournament(sportId: String, tournamentId: String, type: SportLivePrematch) {
        var request = Bb_Mobile_OddinTreeWs_UnsubscribeTournamentRequest()
        request.tournamentID = tournamentId
        request.sportID = sportId
        request.type = type.rawValue
        cyberSportWs.sendRequest(type: .unsubscribeTournament(request))
    }
    
    
    func sendSubscribeTournament(sportId: String, tournamentId: String, type: SportLivePrematch) {
        var request = Bb_Mobile_OddinTreeWs_SubscribeTournamentRequest()
        request.tournamentID = tournamentId
        request.sportID = sportId
        request.type = type.rawValue
        cyberSportWs.sendRequest(type: .subscribeTournament(request))
    }
    func sendUnsubscribeSport(id: String, type: SportLivePrematch) {
        var request = Bb_Mobile_OddinTreeWs_UnsubscribeSportRequest()
        request.sportID = id
        request.type = type.rawValue
        cyberSportWs.sendRequest(type: .unsubscribeSport(request))
    }
    
    
    func sendSetSetting(filter: String) {
        var request = Bb_Mobile_OddinTreeWs_SetSettingsRequest()
        request.timeFilter = filter
        cyberSportWs.sendRequest(type: .setSettings(request))
    }
    
    func sendSubscribeState() {
        let request = Bb_Mobile_OddinTreeWs_SubscribeStateRequest()
        cyberSportWs.sendRequest(type: .subscribeState(request))
    }
    
    
    func subscribeResponseWsConnected(onNext: @escaping (Bool) -> Void) {
        cyberSportWs.subjects.wsConnected
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    
    func wsConnect() {
        
        cyberSportWs.connect()
    }
    
    func wsStart() {
        cyberSportWs.start()
    }
    
    func subscribeResponseSetSetting(
        onNext: @escaping (Bool) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.setSettingResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                onNext(true)
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    
    func sendSubscribeSport(id: String, type: SportLivePrematch) {
        var request = Bb_Mobile_OddinTreeWs_SubscribeSportRequest()
        request.sportID = id
        request.type = type.rawValue
        cyberSportWs.sendRequest(type: .subscribeSport(request))
    }
    
    func subscribeResponseState(
        onNext: @escaping (CSState) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.stateResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                onNext(CSState.entity(from: element))
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    func subscribeResponseSport(
        onNext: @escaping (CSSport) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.sportResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                onNext(CSSport.entity(from: element.sport))
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    
    func subscribeUpdateSport(
        onNext: @escaping (SportEventAction?, CSSport) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.sportUpdateResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                let action = SportEventAction(rawValue: element.action)
                let item = CSSport.entity(from: element.sport)
                onNext(action, item)
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    func subscribeUpdateTournament(
        onNext: @escaping (SportEventAction?, CSTournament) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.tournamentUpdateResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                let action = SportEventAction(rawValue: element.action)
                let item = CSTournament.entity(from: element.tournament)
                onNext(action, item)
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    func subscribeUpdateMatch(
        onNext: @escaping (SportEventAction?, CSMatch) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.matchUpdateResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            
            if element.code == 200 {
                let action = SportEventAction(rawValue: element.action)
                let item = CSMatch.entity(from: element.match)
                onNext(action, item)
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    func subscribeResponseTournament(
        onNext: @escaping (CSTournament) -> Void,
        onError: @escaping (String) -> Void
    ) {
        cyberSportWs.subjects.tournamentResponse.subscribe { response in
            guard let element = response.element else {
                onError("Неизвестная ошибка")
                return
            }
            if element.code == 200 {
                onNext(CSTournament.entity(from: element.tournament))
                return
            }
            let message = element.error.message.isEmpty ? "Неизвестная ошибка" : element.error.message
            onError(message)
        }.disposed(by: disposeBag)
    }
    
    func gamblerTagsRequest(
        _ completion: @escaping (Result<Bb_StoriesGetResponse, Endpoint.ApiError>) -> ()
    ) {
        api.getGamblerTags(completion)
    }
    
    func getGamblerId() -> String {
        let gamblerId = session.getCustomFields()?["gamblerId"]?.value as? Int
        
        if let id = gamblerId {
            return "\(id)"
        } else { return "" }
    }
    
}


enum AppActiveState {
    case background
    case foreground
}
