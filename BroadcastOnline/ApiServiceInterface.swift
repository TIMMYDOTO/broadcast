//
//  ApiServiceInterface.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import Foundation

protocol ApiServiceInterface {
    
    var contentUrl: String { get }
    
    func getGamblerTags(_ completion: @escaping (Result<Bb_StoriesInappstoryGetGamblerTagsResponse, Endpoint.ApiError> ) -> ())
    func getCaptcha(
        color: String,
        state: String,
        _ completion: @escaping (Result<Bb_GetCaptchaResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoverySendSms(request: Bb_PasswordRecoverySendSmsRequest,_ completion: @escaping (Result<Bb_PasswordRecoverySendSmsResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoveryCheckSms(request: Bb_PasswordRecoveryCheckSmsRequest, _ completion: @escaping (Result<Bb_PasswordRecoveryCheckSmsResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoveryChangePassword(request: Bb_PasswordRecoveryChangePasswordRequest, _ completion: @escaping (Result<Bb_PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ())
    
    func smsRepeat(sessionId: String, _ completion: @escaping (Bb_RegisterAuthPhoneRepeatResponse?, Endpoint.ApiError?) -> ())
    
    func authPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<Bb_RegisterStartResponse, Endpoint.ApiError>) -> ())
    
    func checkSms(code: String, sessionId: String, _ completion: @escaping (Result<Bb_RegisterCheckSmsResponse, Endpoint.ApiError>) -> ())
    
    func login(gambler: Gambler, _ completion: @escaping (Result<Bb_AuthLoginResponse, Endpoint.ApiError>) -> ())
    
    func registerAuthPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<Bb_RegisterAuthPhoneResponse, Endpoint.ApiError>) -> ())
}

