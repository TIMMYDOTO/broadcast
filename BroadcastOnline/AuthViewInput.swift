//
//  AuthViewInput.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 01.12.2023.
//

import Foundation
protocol AuthViewInput:NSObjectProtocol {
    func updateCaptcha(isEnabled: Bool, data: String)
    func setSelectedFilter(_ filter: SignType)
    func showPhone(_ cs: CaretString)
    func setClearPhoneButtonIsShown(_ isShown: Bool) 
    func setPhoneIsConfirmable(_ isConfirmable: Bool) 
    func enableSubmitButton()
    func disableSubmitButton()
    func showCheckSmsController(sessionId: String)
    func popViewController()
    func addTimerToSubmitButton()
    func setPasswordIsConfirmable(_ isConfirmable: Bool)
    func checkboxIsChecked() -> Bool 
}
