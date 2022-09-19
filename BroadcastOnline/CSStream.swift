//
//  CSStream.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import Foundation

struct CSStream: Codable, Hashable {
    var name: CSStreamType?
    var streamURL: String = String()
}

extension CSStream {
    static func entity(from: Bb_Mobile_OddinTreeWs_Match.Stream) -> Self {
        var entity = CSStream()
        entity.name = CSStreamType(rawValue: from.name)
        entity.streamURL = from.streamURL
        return entity
    }
}

enum CSStreamType: String, Codable, Hashable {
    case youtube = "Youtube"
    case twitch = "Twitch"
}
