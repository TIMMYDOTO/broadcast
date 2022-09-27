//
//  ConnectManagerDependency.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 30.07.2021.
//

import Foundation

fileprivate let connectManagerService = ConnectManager()

protocol ConnectManagerDependency {
    var connectManager: ConnectManagerInterface { get }
}

extension ConnectManagerDependency {
    var connectManager: ConnectManagerInterface { connectManagerService }
}



