//
//  CheckSmsViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 18.12.2023.
//

import UIKit

class CheckSmsViewController: UIViewController, ApiServiceDependency {
    
    private var stackView: AuthSmsCodeStackView!
    
    private var titleLabel: UILabel!
    
    private var textField: UITextField!
    
    private var subtitleLabel: UILabel!
    
    private var topBackgroundImageView: UIImageView!
    
    private var containerView: UIView!
    
    private var logoImageView: UIImageView!
    
    private var code = String()
    
    private var errorLabel: UILabel!
    private var isRecovery: Bool!
    var phoneNumber: String!
    var sessionId: String!
    

    init(phoneNumber: String, sessionId: String, isRecovery: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumber = phoneNumber
        self.sessionId = sessionId
        self.isRecovery = isRecovery
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
//        setupView()
        setupTopBackgroundImageView()
  
        setupTextField()
      

//        setupSubmitButton()
//        setupResignFirstResponderGesture()
//        setupNotifications()
//        setupDismiss()
        setupNavigationBar()
        setupContainerView()
        setupLogoImageView()
        setupTitle()
        setupSubtitle()
        setupStackView()
        setupErrorLabel()
        
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let firstColor = #colorLiteral(red: 0.05098039216, green: 0.06274509804, blue: 0.09019607843, alpha: 1)
        let secondColor = #colorLiteral(red: 0.1098039216, green: 0.1333333333, blue: 0.1882352941, alpha: 1)
        self.containerView.applyGradient(colours: [firstColor, secondColor])
    }
    
    func setupLogoImageView() {
        let logoImgView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.top.equalTo(containerView.snp.top).offset(-60)
            
        }
        logoImageView = logoImgView
    }
    


    private func setupErrorLabel() {
        let l = UILabel()
        l.textColor = UIColor(hex: 0xFF0025)
        l.text = "Неверный код подтверждения"
        l.textAlignment = .center
        l.font = R.font.lato_BBRegular(size: 13)
        l.isHidden = true
        view.addSubview(l)
        l.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(15)
        }
        
        self.errorLabel = l
    }
    
    
    func setupContainerView() {
        let containerView = UIView()
        containerView.layer.cornerRadius = 24
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBackgroundImageView.snp.bottom).offset(-22)
        }
  
        self.containerView = containerView
    }
    
    func setupTopBackgroundImageView() {
        let imageView = UIImageView(image: UIImage(named: "background"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.26)
        }
        topBackgroundImageView = imageView
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
    
    private func setupTitle() {
        let l = UILabel()
        l.text = "Подтверждение"
        l.textAlignment = .center
        l.font = R.font.robotoBold(size: 20)
        l.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.87)
        containerView.addSubview(l)
        l.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(56)
            $0.height.equalTo(24)
        }
        
        self.titleLabel = l
    }
    
    private func setupSubtitle() {
        let l = UILabel()
        l.numberOfLines = 2
        l.text =
        """
        СМС с кодом подтверждения
        отправлено на номер \(phoneNumber ?? "")
        """
        l.textAlignment = .center
        l.textColor = #colorLiteral(red: 0.5960784314, green: 0.6235294118, blue: 0.6705882353, alpha: 1)
        l.font = R.font.lato_BBRegular(size: 13)
        containerView.addSubview(l)
        l.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(48)
        }
        
        self.subtitleLabel = l
    }
    
    private func setupStackView() {
        let sv = AuthSmsCodeStackView(length: 6, frame: .zero)
        let gr = UITapGestureRecognizer()
        gr.addTarget(self, action: #selector(tapShowKeyboard))
        sv.addGestureRecognizer(gr)
        containerView.addSubview(sv)
        sv.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        self.stackView = sv
    }
    
    @objc func tapShowKeyboard() {
        textField.becomeFirstResponder()
//        didBecomeFirstResponder?()
    }
    
    private func setupTextField() {
        let tf = UITextField()
        tf.textContentType = .oneTimeCode
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .dark
        view.addSubview(tf)
        tf.isHidden = true
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        self.textField = tf
    }
    
    @objc func editingChanged() {
        guard let text = textField.text else { return }
        didChangeEditing(text: text)
    }
    
    func didChangeEditing(text: String) {
        hideError()
        code = String(text.prefix(6))
       
        showCode(code)
        if code.count == 6 {
            checkCode()
        }
    }
    
    func goToNewPasswordController() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordViewController") as! NewPasswordViewController
        vc.sessionId = self.sessionId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkCode() {
        if isRecovery {
            
            api.passwordRecoveryCheckSms(smsCode: code, sessionId: sessionId) { result in
                if case .success(let success) = result {
                    print("success", success)
                    self.goToNewPasswordController()
                    
                }else if case .failure(let failure) = result {
                    switch failure {
                    case .serverError(let message):
                        self.showError(message)
                        
                    default:
                        self.showError("Неизвестная ошибка")
                    }
                    
                }
            }
        }else{
            api.checkSms(code: code, sessionId: sessionId) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case let .success(result):
                    let status = ConfirmCodeSuccess(rawValue: (result.userStatus ?? .none)!)
                    
                    switch status {
                    case .alreadyIdentified:
                        self.showSuccess()
                    case .notIdentfied:
                        self.showSuccess()
                    case .alreadyRegistered:
                        self.showAlreadyRegistered()
                        
                    case .none:
                        print("none")
                        self.showError("Неизвестная ошибка")
                  
                    }
                case let .failure(error):
                    switch error {
                    case .serverError(let message):
                        self.showError(message)
                        
                    default:
                        self.showError("Неизвестная ошибка")
                    }

                }
            }
        }
      
    }
    
    func showSuccess() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpFinishedViewController") as! SignUpFinishedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlreadyRegistered() {
        let vc = ResultAlreadyRegisteredViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCode(_ code: String) {
        textField.text = code
        stackView.setCode(code)
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}


enum ConfirmCodeError: String {
    case registerSmsLimitExceed = "RegisterSmsCheckLimitExceedDetails"
    case userBlocked = "UserIsBlockedDetails"
    case badRequestErrorDetails = "BadRequestErrorDetails"
    case timeOutErrorDetails = "TimeOutErrorDetails"
    case identificationSmsLimitExceed = "IdentificationSmsLimitExceedDetails"
}

enum ConfirmCodeSuccess: String {
    case alreadyIdentified = "new_valid"
    case notIdentfied = "new_invalid"
    case alreadyRegistered = "old"
    
}
