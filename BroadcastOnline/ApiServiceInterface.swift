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
    func getCaptcha(color: String, state: String, _ completion: @escaping (Result<GetCaptchaResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoveryCheckSms(smsCode: String, sessionId: String, _ completion: @escaping (Result<PasswordRecoveryCheckSmsResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoveryChangePassword(password: String, sessionId: String, _ completion: @escaping (Result<PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ()) 
    
    func smsRepeat(sessionId: String, _ completion: @escaping (Bb_RegisterAuthPhoneRepeatResponse?, Endpoint.ApiError?) -> ())
    
    func authPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<Bb_RegisterStartResponse, Endpoint.ApiError>) -> ())
    
    func checkSms(code: String, sessionId: String, _ completion: @escaping (Result<RegisterCheckSmsResponse, Endpoint.ApiError>) -> ())
    
    func login(gambler: Gambler, _ completion: @escaping (Result<AuthLoginResponse, Endpoint.ApiError>) -> ())
    
    func registerAuthPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<RegisterAuthPhoneResponse, Endpoint.ApiError>) -> ())
    
    func passwordRecoverySendSms(phone: String, captcha_key: String?, captcha: String?, _ completion: @escaping (Result<PasswordRecoverySendSmsResponse, Endpoint.ApiError>) -> ())
    
    func newPassword(password: String, sessionId: String,  _ completion: @escaping (Result<PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ())
}

