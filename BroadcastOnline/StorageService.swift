//
//  StorageService.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import Foundation

final class StorageService: StorageServiceInterface {
    private let defaults = UserDefaults.standard
    
    func object(forKey defaultName: String) -> Any? {
        defaults.object(forKey: defaultName)
    }
    
    func integer(forKey defaultName: String) -> Int {
        defaults.integer(forKey: defaultName)
    }
    
    func float(forKey defaultName: String) -> Float {
        defaults.float(forKey: defaultName)
    }
    
    func double(forKey defaultName: String) -> Double {
        defaults.double(forKey: defaultName)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        defaults.bool(forKey: defaultName)
    }
    
    func string(forKey defaultName: String) -> String? {
        defaults.string(forKey: defaultName)
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        defaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Float, forKey defaultName: String) {
        defaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        defaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        defaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        defaults.set(value, forKey: defaultName)
    }
    
    func remove(forKey defaultName: String) {
        defaults.removeObject(forKey: defaultName)
    }
    
    //
    func object(key: UserDefaultKey) -> Any? {
        defaults.object(forKey: key.rawValue)
    }
    
    
    func set(_ value: Any?, key: UserDefaultKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func set(_ value: Double, forKey defaultName: UserDefaultKey) {
        defaults.set(value, forKey: defaultName.rawValue)
    }
    
    func set(_ value: Bool, forKey defaultName: UserDefaultKey) {
        defaults.set(value, forKey: defaultName.rawValue)
    }
    
    func set(_ value: Int, forKey defaultName: UserDefaultKey) {
        defaults.set(value, forKey: defaultName.rawValue)
    }
    
    func double(forKey defaultName: UserDefaultKey) -> Double {
        defaults.double(forKey: defaultName.rawValue)
    }
    
    func bool(forKey defaultName: UserDefaultKey) -> Bool {
        defaults.bool(forKey: defaultName.rawValue)
    }
    
    func integer(forKey defaultName: UserDefaultKey) -> Int {
        defaults.integer(forKey: defaultName.rawValue)
    }
    
    func remove(key: UserDefaultKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func set(_ value: String, forKey defaultName: UserDefaultKey) {
        defaults.set(value, forKey: defaultName.rawValue)
    }
    
    func string(forKey defaultName: UserDefaultKey) -> String? {
        defaults.string(forKey: defaultName.rawValue)
    }

    
}

enum UserDefaultKey: String {
    case namespace = "namespace_v2"
    
    case isBiometricOn = "IsBiometricOn"
    case passcode = "passcode"
    
    case templatesStakeSum = "templatesStakeSum" // шаблоны сумм ставок
    case sportSettings = "sportSettings"
    case lastBetAmount = "lastBetAmount" // сумма последней ставки
    case sportSearchLastRequests = "sportSearchLastRequests"
    case rebuySumChangeAgreement = "rebuySumChangeAgreement"
    
    //hints
    case sportHintSwitchLivePrematchIsShown = "sportHintSwitchLivePrematchIsShown"
    case sportHintStakesScrollingIsShown = "sportHintStakesScrollingIsShown"
    case sportHintAddFavoriteIsShown = "sportHintAddFavoriteIsShown"
    case settingsHintChangingCoefIsShown = "settingsHintChangingCoefIsShown"
    case sportHintLiveIsShown = "sportHintLiveIsShown"
    
    
    //betsHistory hints
    case betsHistorySportHint = "betsHistorySportHint"
    case betsHistoryGameHint = "betsHistoryGameHint"
    //
    case identTechSupportHint = "identTechSupportHint"
    case betsHistoryTechSupportHint = "betsHistoryTechSupportHint"
    
    //payments
    case payoutFavoriteId = "payoutFavoriteId"
    case payinFavoriteId = "payinFavoriteId"
    
    case betsHistoryGetFavoriteGameProduct = "betsHistoryGetFavoriteGameProduct"

    //firebase
    case firebaseToken = "firebaseToken"
    
    case favoriteGameProduct = "favoriteGameProduct"
}
