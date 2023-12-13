//
//  SessionServiceInterface.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import SwiftyJWT

protocol SessionServiceInterface: AnyObject {
    
    var token: String? { get set }
    
    var refreshToken: String? { get set }
    
    var hasToken: Bool { get }
    
    func removeToken()
    
    func checkTokenExpiration() -> Bool
    
    func checkRefreshTokenExpiration() -> Bool
    
    func getCustomFields() -> [String: EncodableValue]?
    
}
