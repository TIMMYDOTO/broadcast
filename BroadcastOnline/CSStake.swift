//
//  CSStake.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSStake: Codable, Hashable {
    var id: String = String()
    var matchId: String = String()
    var active: Bool = false
    var name: String = String()
    var shortName: String = String()
    var code: Int32 = 0
    var order: Int32 = 0
    var argument: Double?
    var factor: Double = 0
    var isForLiveTv: Bool = false
    var isShowSign: Bool = false
    var stakeTypeID: String = String()
    var stakeType: String = String()
    var stakeTypeOrder: Int32 = 0
    var stakeTypeView: String = String()
    var typeGroupID: Int32 = 0
    var typeGroupName: String = String()
    var typeGroupOrder: Int32 = 0
    var oldFactor: Double?
    var startFactor: Double?
    var periodName: String = String()
    
}

extension CSStake {
    static func entity(from: Bb_Mobile_OddinTreeWs_Stake) -> Self {
        var entity = CSStake()
        entity.id = from.id
        entity.matchId = from.matchID
        entity.active = from.active
        entity.name = from.name
        entity.shortName = from.shortName
        entity.code = from.code
        entity.order = from.order
        entity.argument = from.hasArgument ? from.argument : nil
        entity.factor = from.factor
        entity.isForLiveTv = from.isForLiveTv
        entity.isShowSign = from.isShowSign
        entity.stakeTypeID = from.stakeTypeID
        entity.stakeType = from.stakeType
        entity.stakeTypeOrder = from.stakeTypeOrder
        entity.stakeTypeView = from.stakeTypeView
        entity.typeGroupID = from.typeGroupID
        entity.typeGroupName = from.typeGroupName
        entity.typeGroupOrder = from.typeGroupOrder
        entity.periodName = from.periodName
        return entity
    }
}
