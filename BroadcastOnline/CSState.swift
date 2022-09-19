//
//  CyberSportState.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.03.2022.
//

import Foundation

struct CSState {
    var live: [CSSportInfo] = []
    var prematch: [CSSportInfo] = []
}

extension CSState {
    static func entity(from: Bb_Mobile_OddinTreeWs_SubscribeStateResponse) -> Self {
        var entity = CSState()
        entity.live = from.live.map { CSSportInfo.entity(from: $0.info) }
        entity.prematch = from.prematch.map { CSSportInfo.entity(from: $0.info) }
        return entity
    }
}
