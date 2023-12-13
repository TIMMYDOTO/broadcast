//
//  SessionService.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import SwiftyJWT

final class SessionService: SessionServiceInterface, StorageServiceDependency {
    
    var token: String? {
        get {
            return tokenValue
        }
        set {
            if tokenValue != newValue {
                tokenValue = newValue
                
                if newValue != nil {
                    storage.set(newValue, forKey: tokenKey)
                } else {
                    storage.remove(forKey: tokenKey)
                }
            }
        }
    }
    
    var refreshToken: String? {
        get {
            return refreshTokenValue
        }
        set {
            if refreshTokenValue != newValue {
                refreshTokenValue = newValue
                
                if newValue != nil {
                    storage.set(newValue, forKey: refreshTokenKey)
                } else {
                    storage.remove(forKey: refreshTokenKey)
                }
            }
        }
    }
    
    var hasToken: Bool {

        if tokenValue == nil || tokenValue == ""{
            return false
        }else {
            return true
        }
        
    }
    
    private let tokenKey = "SessionToken"
    private let refreshTokenKey = "SessionRefreshToken"
    
    private var tokenValue: String?
    private var refreshTokenValue: String?
    
    init() {
        tokenValue = storage.string(forKey: tokenKey)
        refreshTokenValue = storage.string(forKey: refreshTokenKey)
        
       
    }
    
    func removeToken() {
        storage.remove(forKey: tokenKey)
        storage.remove(forKey: refreshTokenKey)
        
        tokenValue = nil
        refreshTokenValue = nil
    }
    
    func checkTokenExpiration() -> Bool {
        if
            let value = tokenValue,
            let encodedPayload = value.components(separatedBy: ".")[safe: 1]
        {
            do {
                let payload = try CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
                try payload.checkExpiration(allowNil: false)
                
                return false
            } catch {
                return true
            }
        } else {
            return true
        }
    }
    
    func checkRefreshTokenExpiration() -> Bool {
        if
            let value = refreshTokenValue,
            let encodedPayload = value.components(separatedBy: ".")[safe: 1]
        {
            do {
                let payload = try CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
                try payload.checkExpiration(allowNil: false)
                
                return false
            } catch {
                return true
            }
        } else {
            return true
        }
    }
    
    func getCustomFields() -> [String: EncodableValue]? {
        if
            let value = tokenValue,
            let encodedPayload = value.components(separatedBy: ".")[safe: 1]
        {
            do {
                let payload = try CompactJSONDecoder.shared.decode(JWTPayload.self, from: encodedPayload)
                
                return payload.customFields
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

