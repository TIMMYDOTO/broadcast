//
//  CyberOdinWsService.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 21.03.2022.
//

import Foundation
import Starscream
import RxSwift

final class CyberOdinWsService: CyberOdinWsServiceInterface {
    
    enum ConnectStatus {
        case connecting
        case connected
        case disconnected
    }
    
    private var typeName: String { String(describing: self) }
    
    private var wsUrlString: String {
        AppDataStore.shared.appConfig.esportTreeWsUrlProd
        
    }
//    private let wsUrlString: String = "wss://betboom.ru/api/oddin_tree_ws/v1"
//    private let wsUrlString: String = "wss://bboncyp-oddin.bb-online-stage.com/api/oddin_tree_ws/v1"
    
    private var webSocket: WebSocket!
    private var connectStatus: ConnectStatus = .disconnected
    
    internal var subjects = CyberOdinWsServiceSubjects()
    
    init() {
        setupNotifications()
    }
    
    func start() {
        connectStatus = .connecting
        debugPrint("\(typeName).START")
        removeSocket()
        setupSocket()
        webSocket.connect()
    }
    
    func connect() {
        connectStatus = .connecting
        debugPrint("\(typeName).CONNECT123")
        setupSocket()
        webSocket.connect()
    }
    
    func disconnect() {
        connectStatus = .disconnected
        debugPrint("\(typeName).DISCONNECT")
        removeSocket()
    }
    
    func checkConnected() -> Bool {
        return connectStatus != .disconnected
    }
    
    func sendRequest(type: Bb_Mobile_OddinTreeWs_MainRequest.OneOf_Type) {
        //debugPrint("\(typeName).sending: \(type)")
        var request = Bb_Mobile_OddinTreeWs_MainRequest()
        request.type = type
        sendMessage(request)
    }
}

extension CyberOdinWsService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case let .connected(headers):
            debugPrint("\(typeName): is connected: \(headers)")
            connectStatus = .connected
            subjects.wsConnected.onNext(true)
        case let .disconnected(reason, code):
            debugPrint("\(typeName): is disconnected: \(reason) with code: \(code)")
            connectStatus = .disconnected
        case .text:
            break
        case let .binary(data):
            handleResponse(data)
        case let .error(error):
            handleError(error)
        case .cancelled:
            debugPrint("\(typeName): didReceive: \(event)")
            break
        case .pong, .ping, .viabilityChanged, .reconnectSuggested:
            //debugPrint("\(typeName): didReceive: \(event)")
            break
        }
    }
    
    
}

private extension CyberOdinWsService {
    func setupSocket() {
        guard webSocket == nil, let url = URL(string: wsUrlString) else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
            
        let socket = WebSocket(request: request)
        socket.delegate = self
        
        webSocket = socket
    }
    
    func removeSocket() {
        if webSocket == nil { return }
        webSocket.disconnect()
        webSocket = nil
    }
    
    func sendMessage(_ request: Bb_Mobile_OddinTreeWs_MainRequest) {
        if webSocket == nil {
            debugPrint("\(typeName): websocket nil")
            return
        }
        
        let data: Data
        do {
            data = try request.serializedData()
        } catch {
            debugPrint("\(typeName): serialize data error")
            return
        }
        
        webSocket.write(data: data)
    }
    
    func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if webSocket == nil { return }
        webSocket.disconnect()
        subjects.appState.onNext(.background)
    }

    @objc func appMovedToForeground() {
        if webSocket == nil { return }
        webSocket.connect()
        subjects.appState.onNext(.foreground)
    }
    
    func handleResponse(_ data: Data) {
        let response: Bb_Mobile_OddinTreeWs_MainResponse
        do {
            response = try Bb_Mobile_OddinTreeWs_MainResponse(serializedData: data)
        } catch {
            debugPrint("\(typeName): decode response data error")
            return
        }
        
        //debugPrint("\(typeName).received: \(String(describing: response.type) )")
        switch response.type {
        case let .setSettings(response):
            subjects.setSettingResponse.onNext(response)
        case let .subscribeState(response):
            subjects.stateResponse.onNext(response)
        case let .stateAwait(response):
            subjects.stateAwait.onNext(response.code == 200)
        case let .stateReady(response):
            subjects.stateReady.onNext(response.code == 200)
        case let .subscribeSport(response):
            subjects.sportResponse.onNext(response)
        case let .subscribeTournament(response):
            subjects.tournamentResponse.onNext(response)
        case let .subscribeFullMatch(response):
            subjects.fullMatchResponse.onNext(response)
        case let .subscribeStake(response):
            subjects.stakeResponse.onNext(response)
        case let .sport(response):
            subjects.sportUpdateResponse.onNext(response)
        case let .tournament(response):
            subjects.tournamentUpdateResponse.onNext(response)
        case let .fullMatch(response):
            subjects.fullMatchUpdateResponse.onNext(response)
        case let .match(response):
            subjects.matchUpdateResponse.onNext(response)
        case let .stake(response):
            subjects.stakeUpdateResponse.onNext(response)
        case let .subscribeFullTournament(response):
            subjects.fullTournamentResponse.onNext(response)
        default:
            break
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            debugPrint("\(typeName): encountered an error: \(e.message)")
        } else if let e = error {
            debugPrint("\(typeName): encountered an error: \(e.localizedDescription)")
        } else {
            debugPrint("\(typeName): encountered an error")
        }
    }
}
