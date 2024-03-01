//
//  ForgetPasswordViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 20.12.2023.
//

import UIKit

class ForgetPasswordViewController: UIViewController, ApiServiceDependency {
    
    private var state: SignUpStartState = .init()
    var capchaIsEnabled = true
    
    @IBOutlet weak var captchaView: UIView!
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var captchaTextField: CaptchaTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!{
        didSet{
            let gr = UITapGestureRecognizer()
            gr.addTarget(self, action: #selector(tapClearPhone))
            gr.cancelsTouchesInView = true
            phoneTextField.rightView.addGestureRecognizer(gr)
            phoneTextField.rightView.isUserInteractionEnabled = false
       
        }
    }
    @IBOutlet weak var continueButton: UIButton!{
        didSet{
            continueButton.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4274509804, blue: 0.6, alpha: 1), for: .normal)
            continueButton.disableButton()
            continueButton.layer.cornerRadius = 12
            continueButton.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var captchaImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCaptcha()
//        captchaTextField.textField.text = ""
//        captchaTextField.updateStatus(message: "")
        captchaTextField.movePlaceholderBack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        continueButton.enbaleButton()
        
    }
    
    func binding() {
        phoneTextField.didChangeEditing = { [weak self] cs in
            guard let self = self else {return}
            var digitsOnly = cs.filtered(with: .decimalDigits)
            
            if digitsOnly.string.first == "8" {
                digitsOnly.string = "7" + digitsOnly.string.dropFirst()
            }
            
            if !digitsOnly.string.isEmpty && digitsOnly.string.first != "7" {
                digitsOnly.insert("7", at: digitsOnly.string.startIndex)
            }
            
            self.state.phone.data = String(digitsOnly.string.prefix(11))
            
            switch self.state.phone.data?.count {
            case 0:
                self.state.phone.validationState = .errorMessage("Обязательное поле")
            case 11:
                self.state.phone.validationState = .success
            default:
                self.state.phone.validationState = .errorMessage("Неверный формат")
            }
            
            let newText: CaretString
            if digitsOnly.string.isEmpty {
                newText = digitsOnly
            } else {
                newText = digitsOnly.formatted(with: "+_ ___ ___ __ __")
            }
            
            showPhone(newText)
            setPhoneIsConfirmable(state.phone.validationState == .success)
            setClearPhoneButtonIsShown(!newText.string.isEmpty)
            updateSubmitButton()
        }
        
        captchaTextField.didChangeEditing = { [weak self] str in
            self?.didChangeEditingCaptcha(str)
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
            captchaTextField.removeError()
        default:
            state.captcha.validationState = .errorMessage("Неверный формат")
        }
        
        print("TEST CAPCHA", state.captcha.validationState )
        updateSubmitButton()
    }
    
    
    @objc func tapClearPhone() {
        let empty = CaretString(string: "", caretPosition: "".startIndex)
        state.phone.data = empty.string
        state.phone.validationState = .errorMessage("Обязательное поле")
        showPhone(empty)
        setPhoneIsConfirmable(false)
        setClearPhoneButtonIsShown(false)
        updateSubmitButton()
    }
    
    private func updateSubmitButton() {
            if state.captcha.isEnabled{
                if state.phone.validationState == .success && state.captcha.validationState == .success {
                    continueButton.enbaleButton()
                }else{
                    continueButton.disableButton()
            }
        } else {
            if state.phone.validationState == .success {
                continueButton.enbaleButton()
            }else{
                continueButton.disableButton()
            }
        }
    }
    
    
    func setClearPhoneButtonIsShown(_ isShown: Bool) {
        let img: UIImage? = isShown ? UIImage(named: "Close") : nil
        phoneTextField.setRightImage(image: img, animated: true)
        phoneTextField.rightView.isUserInteractionEnabled = isShown
    }
    
    func showPhone(_ cs: CaretString) {
        let mas = NSMutableAttributedString(string: cs.string, attributes: [
            .font: R.font.lato_BBRegular(size: 16)!,
            .foregroundColor: BBTheme.isNight() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x0D0D0D)
        ])

        if let i = mas.string.firstIndex(of: "_") {
            let r = i..<mas.string.endIndex
            mas.addAttribute(.kern, value: 0.58, range: NSRange(r, in: cs.string))
            mas.addAttribute(.foregroundColor, value: BBTheme.isNight() ? UIColor(hex: 0x737373) : UIColor(hex: 0xA1A3AB), range: NSRange(r, in: cs.string))
        }
        
        let tf: UITextField = phoneTextField.textField

        tf.attributedText = mas

        if let targetPosition = tf.position(from: tf.beginningOfDocument, offset: cs.caretOffset) {
            tf.selectedTextRange = tf.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func setPhoneIsConfirmable(_ isConfirmable: Bool) {
        phoneTextField.setConfirmButtonEnabled(isConfirmable)
    }
    
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(goBack))
        backButton.theme_tintColor = ThemeColor.iconPrimary
        self.navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        sendSms()
      
    }
    

    
    func sendSms() {
        let phone = phoneTextField.textField.text?.digits ?? ""
        let captcha = captchaTextField.textField.text ?? ""
        let captchaKey = state.captchaKey
        api.passwordRecoverySendSms(phone: phone, captcha_key: captchaKey, captcha: captcha) {[weak self] result in
            guard let self = self else { return }
            if case .success(let success) = result {
                print("succes", success)
                self.showCheckSmsController(sessionId: success.sessionId ?? "")

            }else if case .failure(let failure) = result {
                switch failure {
                case .serverError(let message):
                    self.showAlert(title: "Ошибка", message: message)
                    
                default:
                    self.showAlert(title: "Ошибка", message: "Неизвестная ошибка")
                }
        
            }
        }
    }
    
    func showCheckSmsController(sessionId: String) {
        let phoneNumber = phoneTextField.textField.text ?? ""
        let vc = CheckSmsViewController(phoneNumber: phoneNumber, sessionId: sessionId, isRecovery: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didTapRepeatCaptcha() {
        getCaptcha()
    }
    
    func getCaptcha() {
        api.getCaptcha(color: "white", state: "captcha_register_enabled") {[weak self] result in
            
            guard let self = self else { return }
            if case .success(let response) = result {
                
                self.state.captchaKey = response.key ?? ""
                print("response ",response.key)
                self.updateCaptcha(isEnabled: response.status != "fail", data: response.data ?? "")
                self.state.captcha.isEnabled = true
//                self.updateSubmitButton()
//                completion(response.isEnabled, response.data, response.key)
            }
        }
    }
    
    func updateCaptcha(isEnabled: Bool, data: String) {
        self.capchaIsEnabled = isEnabled
        
        if !isEnabled{
            captchaView.isHidden = true
//            stackViewHeightConstraint.constant = stackViewHeightConstraint.constant - 48
        }else{
            captchaImageView.image = UIImage(base64: data)
            captchaView.isHidden = false
        }

    }
    
    @IBAction func didTapRepeat(_ sender: UIButton) {
        getCaptcha()
    }
}
