//
//  Gambler.swift
//  BetBoomUITests
//
//  Created by Занков Владимир Владимирович on 18.01.2021.
//

import Foundation

struct Gambler: CustomStringConvertible {
    
    var phone: String
    var password: String
    var birthDate: Date
    
    init(phone: String, password: String, birthDate: Date = Date()) {
        self.phone = phone
        self.password = password
        self.birthDate = birthDate
   
    }
    
    public var description: String {
        return "gambler +\(phone)"
    }
    
    static func id1() -> Gambler {
        return Gambler(phone: "79061112233", password: "12345678")
    }
    
    static func withRewards() -> Gambler {
        return Gambler(phone: "79055190667", password: "00000000")
    }
    
    static var vikaProd: Gambler {
        return Gambler(phone: "79057131708", password: "10101010")
    }
}




