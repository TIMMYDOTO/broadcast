//
//  CyberOdinWsServiceInterface.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 21.03.2022.
//

import Foundation

protocol CyberOdinWsServiceInterface {
    
    var subjects: CyberOdinWsServiceSubjects { get }
    
    
    func start()
    
    func connect()
    
    func checkConnected() -> Bool 
    
    func sendRequest(type: Bb_Mobile_OddinTreeWs_MainRequest.OneOf_Type)
    
}
