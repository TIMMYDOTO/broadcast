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
    case getCaptcha = "/getCaptcha"
    case passwordRecoverySendSms = "/passwordRecovery/sendSms"
    case passwordRecoveryCheckSms = "/passwordRecovery/checkSms"
    case passwordRecoveryChangePassword = "/passwordRecovery/changePassword"
    case authPhoneRepeat = "/register/auth_phone_repeat"
    case authPhone = "/register/start"
    case registerCheckSms = "/register/authSms"
    case login = "/login"
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
    
    private var headers = HTTPHeaders(["Content-Type": "application/json",
                                       "x-device-os-name": "ios",
                                       "version": "1.1",
                                       "x-device-os-version": UIDevice.current.systemVersion])
    
//    private var headers = HTTPHeaders(["Content-Type": "application/octet-stream",
//                                       "x-device-os-name": "ios",
//                                       "version": "2",
//                                       "x-device-os-version": UIDevice.current.systemVersion])
    
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
    
    func registerAuthPhone(gambler: Gambler, captchaKey: String, _ completion: @escaping (Result<RegisterAuthPhoneResponse, Endpoint.ApiError>) -> ()) {
        
        let endpoint = Endpoint.registerAuthPhone.rawValue
        let parameters: [String: Any] = ["phone": gambler.phone.digits,
                                   "password": gambler.password,
                                   "confirmInfo": true,
                                   "confirmInfoRules": true]
        
        headers.remove(name: "x-access-token")
        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData { (apiResponse) in
                guard let data = apiResponse.data else {
                    completion(.failure(.noData))
                    return
                }
                
                if let registerResponse = try? JSONDecoder().decode(RegisterAuthPhoneResponse.self, from: data) {
                    completion(.success(registerResponse))
                }else if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                    let meessage = json["message"] as? String
                    completion(.failure(.serverError(meessage ?? "Неизвестная Ошибка. Попробуйте позже")))
                }else{
                    completion(.failure(.serverError("Неизвестная Ошибка. Попробуйте позже")))
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
    
    func getCaptcha(color: String, state: String, _ completion: @escaping (Result<GetCaptchaResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.getCaptcha.rawValue
        
        
        AF.request(self.baseUrl + endpoint,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData { (apiResponse) in
                guard let data = apiResponse.data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let captchaResponse = try JSONDecoder().decode(GetCaptchaResponse.self, from: data)
                    completion(.success(captchaResponse))
                    
                } catch let error {
                    print("error", error)
                    completion(.failure(.wrongData))
                }
            }

    }
    
    func passwordRecoverySendSms(phone: String, captcha_key: String?, captcha: String?, _ completion: @escaping (Result<PasswordRecoverySendSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoverySendSms.rawValue
        updateHeaders()
        
        
        let parameters: [String: Any] = ["phone": phone,
                                         "captcha_key": captcha_key ?? "",
                                         "captcha": captcha ?? ""]
        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData  { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
//                    let meessage = json["message"] as? String
                    let passwordRecoverySendSms = try JSONDecoder().decode(PasswordRecoverySendSmsResponse.self, from: data)
                    
                    guard let error = passwordRecoverySendSms.errors?.first?["message"] else {
           
                        completion(.success(passwordRecoverySendSms))
                        return}
                    
                    switch error {
                    case .message(let msg):
                        completion(.failure(.serverError(msg)))
                    
                    case .reason(_):
                        break
                    }
                } catch let decodingEror{
                    print("123decodingEror", decodingEror)
                    completion(.failure(.wrongData))
                }
                
                
                
                
//                if let passwordRecoverySendSms = try? JSONDecoder().decode(PasswordRecoverySendSmsResponse.self, from: data) {
//                    completion(.success(passwordRecoverySendSms))
//                }else if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
//                    let meessage = json["message"] as? String
//                    
//                    completion(.failure(.serverError(meessage ?? "Неизвестная Ошибка. Попробуйте позже")))
//                }else{
//                    completion(.failure(.wrongData))
//                }
        }
    }
    
    func passwordRecoveryCheckSms(smsCode: String, sessionId: String, _ completion: @escaping (Result<PasswordRecoveryCheckSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoveryCheckSms.rawValue
        
        let parameters: [String: Any] = ["smsCode": smsCode,
                                         "sessionId": sessionId]
        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData  { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
//                    let meessage = json["message"] as? String
                    let changePasswordResponse = try JSONDecoder().decode(PasswordRecoveryCheckSmsResponse.self, from: data)
                    
                    guard let error = changePasswordResponse.errors?.first?["message"] else {
                        completion(.success(changePasswordResponse))
                        return}
                    
                    switch error {
                    case .message(let msg):
                        completion(.failure(.serverError(msg)))
                    
                    case .reason(_):
                        break
                    }
                } catch let decodingEror{
                    print("123decodingEror", decodingEror)
                    completion(.failure(.wrongData))
                }
        }
    }
    
    func passwordRecoveryChangePassword(password: String, sessionId: String, _ completion: @escaping (Result<PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.passwordRecoveryChangePassword.rawValue
        
        
        let parameters: [String: Any] = ["password": password,
                                         "sessionId": sessionId]
        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData  { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
            
                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//
//                    let meessage = json["message"] as? String
                    let changePasswordResponse = try JSONDecoder().decode(PasswordRecoveryChangePasswordResponse.self, from: data)
                    completion(.success(changePasswordResponse))
                    
                } catch let decodingEror{
                    print("decodingEror", decodingEror)
                    completion(.failure(.wrongData))
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
    
    
    func checkSms(code: String, sessionId: String, _ completion: @escaping (Result<RegisterCheckSmsResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.registerCheckSms.rawValue
        
        let parameters: [String: Any] = ["smsCode": code,
                                         "sessionId": sessionId,
                                         "appsflyerId": "0000000000000-0000000"]

        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData  { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
//                    let meessage = json["message"] as? String
                    let registerResponse = try JSONDecoder().decode(RegisterCheckSmsResponse.self, from: data)
                    
                    guard let error = registerResponse.errors?.first?["message"] else {
                        self.session.token = registerResponse.token
                        self.session.refreshToken = registerResponse.refreshToken
                        completion(.success(registerResponse))
                        return}
                    
                    switch error {
                    case .message(let msg):
                        completion(.failure(.serverError(msg)))
                    
                    case .reason(_):
                        break
                    }
                } catch let decodingEror{
                    print("123decodingEror", decodingEror)
                    completion(.failure(.wrongData))
                }
                
                
                
                
                
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//  //
//  //                let meessage = json["message"] as? String
//                    
//                    let registerResponse = try JSONDecoder().decode(RegisterCheckSmsResponse.self, from: data)
//                    self.session.token = registerResponse.token
//                    self.session.refreshToken = registerResponse.refreshToken
//                    completion(.success(registerResponse))
//            
//                } catch let decodingEror{
//                    print("decodingEror", decodingEror)
//                    completion(.failure(.wrongData))
//                }
        }
    }
    
    func newPassword(password: String, sessionId: String,  _ completion: @escaping (Result<PasswordRecoveryChangePasswordResponse, Endpoint.ApiError>) -> ()) {
        updateHeaders()
        
        let endpoint = Endpoint.passwordRecoveryChangePassword.rawValue
        
        let parameters: [String: Any] = ["password": password,
                                         "sessionId": sessionId
        ]

        
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData  { (apiResponse) in
            guard let data = apiResponse.data else {
                completion(.failure(.noData))
                return
            }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//
//                    let meessage = json["message"] as? String
                    let passwordRecoverySendSms = try JSONDecoder().decode(PasswordRecoveryChangePasswordResponse.self, from: data)
                    completion(.success(passwordRecoverySendSms))
                    
                } catch let decodingEror{
                    print("decodingEror", decodingEror)
                    completion(.failure(.wrongData))
                }
        }
        
    }
    
    
    func login(gambler: Gambler, _ completion: @escaping (Result<AuthLoginResponse, Endpoint.ApiError>) -> ()) {
        let endpoint = Endpoint.login.rawValue
        updateHeaders()
        
        let parameters: [String: Any] = ["phone": gambler.phone.digits,
                                         "password": gambler.password,
                                         "appsflyerId": ""]
        
        headers.remove(name: "x-access-token")
        AF.request(self.baseUrl + endpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: self.headers)
            .responseData { (apiResponse) in
                guard let data = apiResponse.data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
//                    let meessage = json["message"] as? String
                    let loginResponse = try JSONDecoder().decode(AuthLoginResponse.self, from: data)
                    
                    guard let error = loginResponse.errors?.first?["message"] else {
                        self.session.token = loginResponse.token
                        self.session.refreshToken = loginResponse.refreshToken
                        completion(.success(loginResponse))
                        return}
                    
                    switch error {
                    case .message(let msg):
                        completion(.failure(.serverError(msg)))
                    
                    case .reason(_):
                        break
                    }
                } catch let decodingEror{
                    print("123decodingEror", decodingEror)
                    completion(.failure(.wrongData))
                }
            }
    }

    
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

