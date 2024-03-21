//
//  Models.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 19.01.2024.
//

import Foundation


struct RegisterAuthPhoneResponse: Codable {
    var sessionId: String?
    var code: Int32 = 0
    var message: String?
    var status: String = String()
    var cupisCode: Int?
    var codeText: String = String()
    var errors: [[String: ErrorMessage]]?
}


struct RegisterCheckSmsResponse: Codable {
    var code: Int32 = 0
    var status: String = String()
    var cupisCode: Int?
    var message: String?
    var userStatus: String?
    var token: String?
    var refreshToken: String?
    var errors: [[String: ErrorMessage]]?
}

struct AuthLoginResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String = String()
    var token: String?
    var refreshToken: String?
    var international: Bool?
    var errors: [[String: ErrorMessage]]?
}

struct GetCaptchaResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String = String()
    var key: String?
    var data: String?
    
}

struct PasswordRecoverySendSmsResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String = String()
    var sessionId: String?
    var errors: [[String: ErrorMessage]]?
}


struct PasswordRecoveryCheckSmsResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String?
    var errors: [[String: ErrorMessage]]?
}

enum ErrorMessage: Codable{
    case message(String)
    case reason(String)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .message(container.decode(String.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .reason(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(ErrorMessage.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .message(let double):
            try container.encode(double)
        case .reason(let string):
            try container.encode(string)
        }
    }
}

struct PasswordRecoveryChangePasswordResponse: Codable {
    var code: Int32 = Int32()
    var codeText: String = String()
    var status: String = String()
}


