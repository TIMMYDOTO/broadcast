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
        getCaptcha()
    
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
        api.authPhone(gambler: gambler) { result in
            if case .success(let success) = result {
                print("succes", success)
            }
        }
    }
    
    func didTapRepeatCaptcha() {
        getCaptcha()
    }
    
    func changeCurrentSignType(_ model: SignType) {
        view?.setSelectedFilter(model)
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
//        guard leftSeconds == nil else { return }
//        let requiredInputs: [AnyAuthInput] = [
//            state.phone.erased, state.password.erased, state.birthDate.erased, state.captcha.erased, state.ageConfirmed.erased
//        ]
//        for input in requiredInputs {
//            if input.isEnabled, input.validationState != .success {
//                view?.disableSubmitButton(isRetry: state.isRetry)
//                return
//            }
//        }
//        view?.enableSubmitButton(isRetry: state.isRetry)
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
