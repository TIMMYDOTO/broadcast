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
    var signType: SignType = .signIn
    public init(view: AuthViewInput ) {
        self.view = view
    }
    
    deinit {
        print()
    }
    
    func viewDidLoad() {
      
    
    }
    
    func getCaptcha() {
        api.getCaptcha(color: "white", state: "captcha_register_enabled") {[weak self] result in
            guard let self = self else { return }
            if case .success(let response) = result {
                
                self.state.captchaKey = response.key ?? ""
                self.state.captcha.data = response.data ?? ""
                self.view?.updateCaptcha(isEnabled: response.status != "fail", data: response.data ?? "")
                self.state.captcha.isEnabled = true
//                self.updateSubmitButton()
//                completion(response.isEnabled, response.data, response.key)
            }
        }
    }
    
    func didTapSignUp(gambler: Gambler, captcha: String) {
        api.registerAuthPhone(gambler: gambler, captchaKey: self.state.captchaKey, captcha: captcha) { [weak self] result in
            guard let self = self else { return }
            if case .success(let success) = result {
                print("success", success)
                self.addTimerToSubmitButton()
                self.view?.showCheckSmsController(sessionId: success.sessionId ?? "")
            } else if case .failure(let failure) = result {
                switch failure {
                case .serverError(let message):
                    self.view?.showAlertError(title: "Ошибка", message: message)
                default:
                    self.view?.showAlertError(title: "Ошибка", message: "Неизвестная ошибка")
                }
        
            }
        }
    }
    
    func addTimerToSubmitButton() {
        view?.disableSubmitButton()
//        view?
        var runCount = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
            guard let self = self else { return }
            state.isBlocked = true
            runCount -= 1
            if self.signType == .signUp{
                self.view?.updateSignUpButtonTitle(text: "Повторный запрос кода через \(runCount) сек")

            }
            
            if runCount == 0 {
                state.isBlocked = false
                timer.invalidate()
                runCount = 60
                updateSubmitButton()
                if self.signType == .signUp{
                    self.view?.updateSignUpButtonTitle(text: "Зарегистрироваться")
                }
            }
        }
    }
    
    
    func didChangeEditingCaptcha(_ cs: CaretString) {
        print("TEST CAPCHA", cs)
        let stringCount = cs.string.count
        switch stringCount {
        case 0:
            state.captcha.validationState = .errorMessage("Обязательное поле")
        case 4:
            state.captcha.validationState = .success
        default:
            state.captcha.validationState = .errorMessage("Неверный формат")
        }
        print("TEST CAPCHA", state.captcha.validationState )
        updateSubmitButton()
    }
    
    func viewWillAppear() {
        getCaptcha()
    }
    
    func didClearCaptchaTextField() {
        updateSubmitButton()
    }
    
    func didTapSignIn(gambler: Gambler) {
        api.login(gambler: gambler) {[weak self] result in
            guard let self = self else { return }
            if case .success(let success) = result {
                print("succes", success)
                self.view?.popViewController()

            }else if case .failure(let failure) = result {
                switch failure {
                case .serverError(let message):
                    self.view?.showAlertError(title: "Ошибка", message: message)
                default:
                    self.view?.showAlertError(title: "Ошибка", message: "Неизвестная ошибка")
                }
        
            }

        }
    }
    
    func didTapRepeatCaptcha() {
        getCaptcha()
    }
    
    func changeCurrentSignType(_ model: SignType) {
        signType = model
        updateSubmitButton()
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
    
    func checkboxIsChecked() -> Bool {
        guard let view = self.view else {return false}
       return view.checkboxIsChecked()
    }
    
    func updateSubmitButton() {
        if signType == .signUp {
            let checkboxIsChecked = checkboxIsChecked()
            if state.captcha.isEnabled{
       
                if state.phone.validationState == .success && state.password.validationState == .success && state.captcha.validationState == .success && checkboxIsChecked, !state.isBlocked {
                    view?.enableSubmitButton()
                }else{
                    view?.disableSubmitButton()
                }
            } else {
                if state.phone.validationState == .success && state.password.validationState == .success && checkboxIsChecked, !state.isBlocked {
                    view?.enableSubmitButton()
                }else{
                    view?.disableSubmitButton()
                }
            }
        }
        
        if signType  == .signIn {
            if state.captcha.isEnabled{
                if state.phone.validationState == .success && state.password.validationState == .success {
                    view?.enableSubmitButton()
                }else{
                    view?.disableSubmitButton()
                }
            } else {
                if state.phone.validationState == .success && state.password.validationState == .success{
                    view?.enableSubmitButton()
                }else{
                    view?.disableSubmitButton()
                }
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
    
    var isBlocked: Bool = false
}

enum SignUpStartError: String {
    case registerSmsLimitExceed = "RegisterSmsLimitExceedDetails"
    case badRequestErrorDetails = "BadRequestErrorDetails"
}
