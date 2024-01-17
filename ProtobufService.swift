//
//  ProtobufService.swift
//  BetBoom
//
//  Created by Vitaliy Kozlov on 23/06/2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//
//

import Alamofire
import SwiftProtobuf
import SwiftyJWT
import InAppStorySDK
//import BetBoomUITests

enum Endpoint: String {

    case getGamblerTags = "/stories/inappstory/get_gambler_tags"
    case getCaptcha = "/get_captcha"
    case passwordRecoverySendSms = "/password_recovery/send_sms"
    case passwordRecoveryCheckSms = "/password_recovery/check_sms"
    case passwordRecoveryChangePassword = "/password_recovery/change_password"
    case authPhoneRepeat = "/register/auth_phone_repeat"
    case authPhone = "/register/start"
    case registerCheckSms = "/register/check_sms"
    case login = "/auth/login"
    case registerAuthPhone = "/register/authPhone"
    
    enum ApiError: Error {
        case noData
        case wrongData
        case serverError(String)
        case errorModel(Bb_BadRequestErrorDetails)
        case errorSmsLimit(Bb_IdentificationSmsLimitExceedDetails)
        case bbError(Bb_Error)
        
    }
}

final class ProtobufService: SessionServiceDependency, ConnectManagerDependency, ApiServiceInterface {

    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    let contentUrl: String
    
    private var headers = HTTPHeaders(["Content-Type": "application/octet-stream",
                                       "x-device-os-name": "ios",
                                       "version": "2",
                                       "x-device-os-version": UIDevice.current.systemVersion])
    
    private var baseUrl: String
    
    init(baseUrl: String, contentUrl: String) {


    

//        self.baseUrl = "https://mobileappv2.betboom.ru/api/mobile/v2"


        self.baseUrl = baseUrl
        self.contentUrl = contentUrl
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            self.headers.add(name: "x-app-version", value: version)
            self.headers.add(name: "x-app-build-type", value: AppState.shared.isDebug ? "dev" : "prod")
        }
        Google_Protobuf_Any.register(messageType: Bb_BadRequestErrorDetails.self)
    }
    
    func setNamespace(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getNamespace() -> String {
        if let nameSpace = UserDefaults.standard.object(forKey: "namespace") as? String {
            return nameSpace
        } else { return "" }
    }
    
    private func checkExpired(completion: @escaping () -> Void) {
        if session.checkTokenExpiration() {
            
            if session.checkRefreshTokenExpiration() {
                print("test2509 check expired result: refresh expired")
                updateHeaders()
            } else {
                print("test2509 check expired result: start refreshing")
//                refreshToken {
//                    self.updateHeaders()
//                    print("test2509 check expired result: refreshing success")
//                    completion()
//                }
                return
            }
            
        } else {
            updateHeaders()
        }
        
        completion()
    }
    
    private func updateHeaders() {
        if session.hasToken {
            self.headers["x-access-token"] = session.token!
        } else {
            self.headers.remove(name: "x-access-token")
        }
        if BBTheme.isNight() {
            self.headers["x-color-theme"] = "black"
        } else {
            self.headers["x-color-theme"] = "white"
        }
    }
    
    
    func getGamblerTags(_ completion: @escaping (Result<Bb_StoriesInappstoryGetGamblerTagsResponse, Endpoint.ApiError>) -> ()) {
        checkExpired {
            let endpoint = Endpoint.getGamblerTags.rawValue
            let parameters = Bb_StoriesInappstoryGetGamblerTagsRequest()
            
            AF.upload(try! parameters.serializedData(), to: self.baseUrl + endpoint, headers: self.headers).responseData { (apiResponse) in
                guard let data = apiResponse.data else {
                    completion(.failure(.noData))
                    return
                }
                
                if let response = try? Bb_StoriesInappstoryGetGamblerTagsResponse(serializedData: data) {
                    if self.checkResponse(response.code, response.status) {
                        
                        completion(.success((response)))
                    } else {
                        completion(.failure(.serverError(response.error.message)))
                    }
                } else {
                    completion(.failure(.wrongData))
                }
            }
        }
        
    }
    
    
    func registerAuthPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<Bb_RegisterAuthPhoneResponse, Endpoint.ApiError>) -> ()) {
        var sessionId: String!
        
        let endpoint = Endpoint.registerAuthPhone.rawValue
        var signUp = Bb_RegisterAuthPhoneRequest()
        signUp.phone = gambler.phone
        signUp.password = gambler.password
        signUp.confirmInfo = Int32(1)
        signUp.confirmInfoRules = Int32(1)
        headers.remove(name: "x-access-token")
        
        AF.upload(try! signUp.serializedData(), to: baseUrl + endpoint, headers: self.headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            
            if let response = try? Bb_RegisterAuthPhoneResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    completion(.success((response)))
                } else {
                    print("response", response)
                    completion(.failure(.bbError(response.error)))
                }
            } else {
                completion(.failure(.wrongData))
            }
        }
       
    }
    
    
    func authPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<Bb_RegisterStartResponse, Endpoint.ApiError>) -> ()){
        var sessionId: String!
        
        let endpoint = Endpoint.authPhone.rawValue
        var signUp = Bb_RegisterStartRequest()
        signUp.phone = gambler.phone.digits
        signUp.password = gambler.password
        signUp.confirmInfo = Int32(1)
        signUp.captchaKey = captchaKey
        signUp.birthDate = dateFormatter.string(from: Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date())

        
        headers.remove(name: "x-access-token")
        
        AF.upload(try! signUp.serializedData(), to: baseUrl + endpoint, headers: self.headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            
            if let response = try? Bb_RegisterStartResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    completion(.success((response)))
                } else {
                    print("response", response)
                    completion(.failure(.bbError(response.error)))
                }
            } else {
                completion(.failure(.wrongData))
            }

       
        }
       
    }
    
    func getCaptcha(color: String, state: String, _ completion: @escaping (Result<Bb_GetCaptchaResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.getCaptcha.rawValue
        var parameters = Bb_GetCaptchaRequest()
        parameters.color = color
        parameters.state = state
        var features = Bb_GetCaptchaRequest.Features()
        features.isSupportConditionalCaptcha = true
        parameters.features = features
        
        AF.upload(try! parameters.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            if let response = try? Bb_GetCaptchaResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    
                    completion(.success((response)))
                } else {
                    completion(.failure(.serverError(response.error.message)))
                }
            } else {
                completion(.failure(.wrongData))
            }
        }
    }
    
    func passwordRecoverySendSms(request: Bb_PasswordRecoverySendSmsRequest, _ completion: @escaping (Result<Bb_PasswordRecoverySendSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoverySendSms.rawValue
        updateHeaders()
        AF.upload(try! request.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            if let response = try? Bb_PasswordRecoverySendSmsResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    
                    completion(.success((response)))
                } else {
                    completion(.failure(.bbError(response.error)))
                }
            } else {
                completion(.failure(.wrongData))
            }
            
        }
    }
    
    func passwordRecoveryCheckSms(request: Bb_PasswordRecoveryCheckSmsRequest, _ completion: @escaping (Result<Bb_PasswordRecoveryCheckSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoveryCheckSms.rawValue
        
        AF.upload(try! request.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            if let response = try? Bb_PasswordRecoveryCheckSmsResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    completion(.success((response)))
                } else {
                    completion(.failure(.bbError(response.error)))
                }
            } else {
                completion(.failure(.wrongData))
            }
        }
    }
    
    func passwordRecoveryChangePassword(request: Bb_PasswordRecoveryChangePasswordRequest, _ completion: @escaping (Result<Bb_PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoveryChangePassword.rawValue
        
        AF.upload(try! request.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            if let response = try? Bb_PasswordRecoveryChangePasswordResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    
                    completion(.success(response))
                    
                } else {
                    
                    completion(.failure(.wrongData))
                    
                }
            }
            
        }
    }
    
    func smsRepeat(sessionId: String, _ completion: @escaping (Bb_RegisterAuthPhoneRepeatResponse?, Endpoint.ApiError?) -> ()) {
        let endpoint = Endpoint.authPhoneRepeat.rawValue
        var smsRepeatRequest = Bb_RegisterAuthPhoneRepeatRequest()
        
        smsRepeatRequest.sessionID = sessionId
        
        AF.upload(try! smsRepeatRequest.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(nil, .noData)
                return
            }
            
            if let response = try? Bb_RegisterAuthPhoneRepeatResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    
                    completion(response, nil)
                    
                } else {
                    
                    completion(nil, .wrongData)
                    
                }
            }
            
        }
    }
    
    
    func checkSms(code: String, sessionId: String, _ completion: @escaping (Result<Bb_RegisterCheckSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.registerCheckSms.rawValue
        var request = Bb_RegisterCheckSmsRequest()
        request.sessionID = sessionId
        request.smsCode = code
        
        AF.upload(try! request.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            if let response = try? Bb_RegisterCheckSmsResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    
                    completion(.success((response)))
                } else {
                    completion(.failure(.bbError(response.error)))
                }
            }
            else {
                completion(.failure(.wrongData))
            }
        }
    }
    
    
    func login(gambler: Gambler, _ completion: @escaping (Result<Bb_AuthLoginResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.login.rawValue
        updateHeaders()
        var auth = Bb_AuthLoginRequest()
        auth.phone = gambler.phone.digits
        auth.password = gambler.password
        var features = Bb_AuthLoginRequest.Features()
        features.isWrongDataSupport = true
        auth.features = features
        
        AF.upload(try! auth.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
            if let response = try? Bb_AuthLoginResponse(serializedData: data) {
                if self.checkResponse(response.code, response.status) {
                    self.session.token = response.token
                    
                    self.session.refreshToken = response.refreshToken
                    print("response", response)
                    completion(.success((response)))
                } else {
                    print("response", response)
                    completion(.failure(.bbError(response.error)))
                }
            } else {
                completion(.failure(.wrongData))
            }
        }
    }
    

    
//    private func refreshToken(completion: (() -> Void)? = nil) {
//        if let token = session.token,
//           let refreshToken = session.refreshToken {
//            let endpoint = Endpoint.refreshToken.rawValue
//            print(baseUrl + endpoint)
//            var request = Bb_AuthRefreshTokenRequest()
//            request.token = token
//            request.refreshToken = refreshToken
//            
//            print("test2509 token: ", token, "\nrefresh: ", refreshToken)
//            self.headers.remove(name: "x-access-token")
//            
//            AF.upload(try! request.serializedData(), to: baseUrl + endpoint, headers: headers).responseData { (apiResponse) in
//                guard let data = apiResponse.data else {
//                    return
//                }
//                
//                if let response = try? Bb_AuthRefreshTokenResponse(serializedData: data) {
//                    if response.code == 200 {
//                        self.session.token = response.token
//                        self.session.refreshToken = response.refreshToken
//                        completion?()
//                    } else {
//                        if response.code == 400 {
//                            do {
//                                let errorModel = try Bb_TokenNotExpiredErrorDetails(serializedData: response.error.details.value)
//                                print(errorModel)
//       //                         return
//                                
//                            }
//                            catch let error  {
//                                print(error.localizedDescription)
//                            }
//                            
//                            do {
//                                let errorModel = try Bb_UserIsBlockedDetails(serializedData: response.error.details.value)
//                                BBAlert.showPushMessage(type: .error, title: errorModel.blockReason, message: errorModel.blockComment)
//                                
//                            }
//                            catch let error  {
//                                print(error.localizedDescription)
//                            }
//                            if self.session.hasToken {
//                                AppMetricaService.shared.send(SignOutEvent.ReauthorizationError(
//                                    isConnected: self.connectManager.checkIsConnected(),
//                                    refreshToken: self.session.refreshToken,
//                                    error: response.error.message
//                                ))
//                            }
//                            GibService.shared.onUserWillLogout()
//                            self.session.removeToken()
//                            self.userService.clearUserState()
//                            self.userService.resetBalanceType()
//                            if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
//                                myDelegate.restartRootView()
//                            }
//                        }
//                        
//                    }
//                }
//            }
//        }
//    }
    
    private func checkResponse(_ code: Int32, _ status: String) -> Bool {
        switch code {
        case 200:
            if status == "OK" {
                return true
            }
        case 403: break
//            refreshToken()
        default:
            return false
        }
        
        return false
    }
    

}

fileprivate let service = SessionService()

extension SessionServiceDependency {
    var session: SessionServiceInterface {
        return service
    }
}

