//
//  ConnectManagerInterface.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 30.07.2021.
//

import RxSwift

protocol ConnectManagerInterface {
    
    var connect: Observable<Bool> { get }
    
    func checkIsConnected() -> Bool
    
}
