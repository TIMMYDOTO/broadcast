//
//  Models.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 19.01.2024.
//

import Foundation


struct RegisterAuthPhoneResponse: Codable {
    var sessionId = String()
    var code: Int32 = 0
    var message: String = String()
    var status: String = String()
    var cupisCode: Int = Int()
    var codeText: String = String()
}


struct RegisterCheckSmsResponse: Codable {
    var code: Int32 = 0
    var status: String = String()
    var cupisCode: Int = Int()
    var message: String = String()
    var userStatus: String = String()
    var token: String?
    var refreshToken: String?
}



struct AuthLoginResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String = String()
    var token: Int = Int()
    var refreshToken: String = String()
    var international: Bool = Bool()
}

