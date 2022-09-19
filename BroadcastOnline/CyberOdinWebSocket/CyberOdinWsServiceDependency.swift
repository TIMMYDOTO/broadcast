//
//  CyberOdinWsServiceDependency.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 21.03.2022.
//

import Foundation

fileprivate let cyberOdinWsService = CyberOdinWsService()

protocol CyberOdinWsServiceDependency {
    
    var cyberSportWs: CyberOdinWsServiceInterface { get }
    
}

extension CyberOdinWsServiceDependency {
    
    var cyberSportWs: CyberOdinWsServiceInterface { return cyberOdinWsService }
    
}
