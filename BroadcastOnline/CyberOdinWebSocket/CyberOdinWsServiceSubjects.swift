//
//  CyberOdinWsServiceSubjects.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 21.03.2022.
//

import RxSwift

class CyberOdinWsServiceSubjects {
    
    let appState = PublishSubject<AppActiveState>()
    
    let wsConnected = PublishSubject<Bool>()
    
    let stateAwait = PublishSubject<Bool>()
    let stateReady = PublishSubject<Bool>()
    
    let setSettingResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SetSettingsResponse>()
    
    let stateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeStateResponse>()
    
    let sportResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeSportResponse>()

    let tournamentResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeTournamentResponse>()
    
    let fullMatchResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeFullMatchResponse>()
    
    let stakeResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeStakeResponse>()
    
    let fullTournamentResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SubscribeFullTournamentResponse>()
    
    
    let sportUpdateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_SportResponse>()
    
    let tournamentUpdateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_TournamentResponse>()
    
    let matchUpdateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_MatchResponse>()
    
    let fullMatchUpdateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_FullMatchResponse>()
    
    let stakeUpdateResponse = PublishSubject<Bb_Mobile_OddinTreeWs_StakeResponse>()
    
}

