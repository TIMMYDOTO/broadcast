////
////  WsService.swift
////  BetBoom
////
////  Created by Козлов Виталий Алексеевич on 07.10.2020.
////  Copyright © 2020 BetBoom. All rights reserved.
////




enum SportEventAction: String, Codable {
    case update = "update"
    case create = "create"
    case delete = "delete"
}

enum SportLivePrematch: String, Codable {
    case live = "live"
    case prematch = "prematch"
}
