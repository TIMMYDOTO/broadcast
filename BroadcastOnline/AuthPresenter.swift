//
//  AuthPresenter.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 01.12.2023.
//

import Foundation

final class AuthPresenter: ApiServiceDependency {
    
    weak var view: AuthViewInput!
    private var state: SignUpStartState = .init()
    
    public init(view: AuthViewInput ) {
        self.view = view
    }
    
    
    func viewDidLoad() {
      
    
    }
    
    func getCaptcha() {
        api.getCaptcha(color: "white", state: "captcha_register_enabled") { result in
            if case .success(let response) = result {
                self.state.captcha.isEnabled = response.isEnabled
                self.state.captchaKey = response.key
                print("response ", response.isEnabled, response.key)
                self.view?.updateCaptcha(isEnabled: response.isEnabled, data: response.data)
//                self.updateSubmitButton()
//                completion(response.isEnabled, response.data, response.key)
            }
        }
    }
    
    func didTapSignUp(gambler: Gambler) {
//        api.authPhone(gambler: gambler, captchaKey: self.state.captchaKey) { result in
//            if case .success(let success) = result {
//                print("succes", success)
//                self.view?.addTimerToSubmitButton()
//                self.view?.showCheckSmsController(sessionId: success.sessionID)
//            }else{
//                print("failure")
//            }
//        }
        
        api.registerAuthPhone(gambler: gambler, captchaKey: self.state.captchaKey) { result in
            if case .success(let success) = result {
                print("success", success)
                self.view?.addTimerToSubmitButton()
                self.view?.showCheckSmsController(sessionId: success.sessionId)
            }else{
                print("failure")
            }
        }
    }
    
    
    func didChangeEditingCaptcha(_ cs: CaretString) {
        let stringCount = cs.string.count
        switch stringCount {
        case 0:
            state.captcha.validationState = .errorMessage("Обязательное поле")
        case 4:
            state.phone.validationState = .success
        default:
            state.phone.validationState = .errorMessage("Неверный формат")
        }
        
    }
    
    func viewWillAppear() {
        getCaptcha()
    }
    
    func didTapSignIn(gambler: Gambler) {
        api.login(gambler: gambler) { result in
            if case .success(let success) = result {
                print("succes", success)
                self.view?.popViewController()
//                self.view?.showCheckSmsController(sessionId: success.sessionID)
            }else{
                print("failure")
            }
        }
    }
    
    func didTapRepeatCaptcha() {
        getCaptcha()
    }
    
    func changeCurrentSignType(_ model: SignType) {
        view?.setSelectedFilter(model)
    }
    
    func didChangeEditingPassword(cs: CaretString) {
        let string = cs.string
        print("string", string)
        if string.count >= 8 {
            state.password.validationState = .success
            print("stringsucces", string)
        }else{
            state.password.validationState = .errorMessage("Неверный формат")
        }
        
        updateSubmitButton()
    }
    
    func didChangeEditingPhone(_ cs: CaretString) {
        var digitsOnly = cs.filtered(with: .decimalDigits)
        
        if digitsOnly.string.first == "8" {
            digitsOnly.string = "7" + digitsOnly.string.dropFirst()
        }
        
        if !digitsOnly.string.isEmpty && digitsOnly.string.first != "7" {
            digitsOnly.insert("7", at: digitsOnly.string.startIndex)
        }
        
        state.phone.data = String(digitsOnly.string.prefix(11))
        
        switch state.phone.data?.count {
        case 0:
            state.phone.validationState = .errorMessage("Обязательное поле")
        case 11:
            state.phone.validationState = .success
        default:
            state.phone.validationState = .errorMessage("Неверный формат")
        }
        
        let newText: CaretString
        if digitsOnly.string.isEmpty {
            newText = digitsOnly
        } else {
            newText = digitsOnly.formatted(with: "+_ ___ ___ __ __")
        }
        
        view?.showPhone(newText)
        view?.setPhoneIsConfirmable(state.phone.validationState == .success)
        view?.setClearPhoneButtonIsShown(!newText.string.isEmpty)
        updateSubmitButton()
    }
    
    
    private func updateSubmitButton() {
            if state.captcha.isEnabled{
                if state.phone.validationState == .success && state.password.validationState == .success && state.captcha.validationState == .success {
                    view?.enableSubmitButton()
                }else{
                    view?.disableSubmitButton()
            }
        } else {
            if state.phone.validationState == .success && state.password.validationState == .success {
                view?.enableSubmitButton()
            }else{
                view?.disableSubmitButton()
            }
        }
    }
    
    func didClearPhone() {
        let empty = CaretString(string: "", caretPosition: "".startIndex)
        state.phone.data = empty.string
        state.phone.validationState = .errorMessage("Обязательное поле")
        view?.showPhone(empty)
        view?.setPhoneIsConfirmable(false)
        view?.setClearPhoneButtonIsShown(false)
        updateSubmitButton()
    
    }
    
}



struct SignUpStartState {
    
    var phone: AuthInput<String> =      .init(isEnabled: true, validationState: .errorMessage("Обязательное поле"))
    
    var password: AuthInput<String> =   .init(isEnabled: true, validationState: .errorMessage("Обязательное поле"))
    
    var birthDate: AuthInput<Date> =    .init(isEnabled: true, validationState: .errorMessage("Обязательное поле"))
    
    var captcha: AuthInput<String> =    .init(isEnabled: false, validationState: .errorMessage("Обязательное поле"))
    
    var promocode: AuthInput<String> =  .init(isEnabled: false, validationState: .default)
    
    var ageConfirmed: AuthInput<Bool> = .init(isEnabled: true, validationState: .default)
    
    var captchaKey: String =        .init()
    
    var deviceId: String =          .init()
    
    var isRetry: Bool =             false
}

enum SignUpStartError: String {
    case registerSmsLimitExceed = "RegisterSmsLimitExceedDetails"
    case badRequestErrorDetails = "BadRequestErrorDetails"
}
