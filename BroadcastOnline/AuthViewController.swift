//
//  AuthViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 30.11.2023.
//

import UIKit

class AuthViewController: UIViewController, AuthViewInput {
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var catpchaView: UIView!
    
    @IBOutlet weak var phoneTextFieldView: PhoneTextField!{
        didSet{
            let gr = UITapGestureRecognizer()
            gr.addTarget(self, action: #selector(tapClearPhone))
            gr.cancelsTouchesInView = true
            phoneTextFieldView.rightView.addGestureRecognizer(gr)
            phoneTextFieldView.rightView.isUserInteractionEnabled = false
       
        }
    }
    
    @IBOutlet weak var passwordTextFieldView: PasswordTextField!
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var captchaImageView: UIImageView!
    @IBOutlet weak var checkBox: BBCheckBox!
    @IBOutlet weak var captchaTextField: CaptchaTextField!{
        didSet{
//            captchaTextField.layer.borderWidth = 1.0
//            captchaTextField.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
//            captchaTextField.layer.cornerRadius = 16
        }
    }

    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4274509804, blue: 0.6, alpha: 1), for: .normal)
            signUpButton.disableButton()
            signUpButton.layer.cornerRadius = 12
            signUpButton.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var textView: NonSelectableTextViewWithTappableLink!
    
    private weak var signTypeCollectionView: SignTypeCollectionView!
    public var presenter: AuthPresenter!
    var currentType: SignType = .signIn{
        didSet{
            if currentType == .signUp {
                makeSignUpType()
            }else{
                makeSignInType()
            }
        }
    }
    var capchaIsEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
        setup()
        presenter.viewDidLoad()
        binding()
        setupNavigationBar()
        currentType = .signIn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func showAlertError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func addTimerToSubmitButton() {
        signUpButton.disableButton()
        var runCount = 30
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
          
            runCount -= 1
            self.signUpButton.setTitle("Повторный запрос кода через \(runCount) сек", for: .normal)
            if runCount == 0 {
                timer.invalidate()
                self.signUpButton.enbaleButton()
                self.signUpButton.setTitle("Зарегистрироваться", for: .normal)
            }
        }
    }
    
    func binding() {
        signTypeCollectionView.willSelect = { [weak self] type in
            self?.currentType = type
            self?.presenter?.changeCurrentSignType(type)
        }
        
        phoneTextFieldView.didChangeEditing = { [weak self] str in
            self?.presenter?.didChangeEditingPhone(str)
        }
        
        passwordTextFieldView.didChangeEditing = { [weak self] str in
            self?.presenter?.didChangeEditingPassword(cs: str)
        }
        
        captchaTextField.didChangeEditing = { [weak self] str in
            self?.presenter?.didChangeEditingCaptcha(str)
        }
    }
    
    func setClearPhoneButtonIsShown(_ isShown: Bool) {
        let img: UIImage? = isShown ? UIImage(named: "Close") : nil
        phoneTextFieldView.setRightImage(image: img, animated: true)
        phoneTextFieldView.rightView.isUserInteractionEnabled = isShown
    }
    
    
    func makeSignUpType() {
        signUpButton.setTitle("Зарегистрироваться", for: .normal)
        checkBox.isHidden = false
        textView.isHidden = false
        forgetPasswordButton.isHidden = true
        if capchaIsEnabled {
            catpchaView.isHidden = false
//            stackViewHeightConstraint.constant = stackViewHeightConstraint.constant + 48
        }
    }
    
    func setPasswordIsConfirmable(_ isConfirmable: Bool) {
        passwordTextFieldView.setConfirmButtonEnabled(isConfirmable)
    }
    
    func makeSignInType() {
        signUpButton.setTitle("Войти", for: .normal)
        checkBox.isHidden = true
        textView.isHidden = true
        forgetPasswordButton.isHidden = false
//        if capchaIsEnabled {
            catpchaView.isHidden = true
//            stackViewHeightConstraint.constant = stackViewHeightConstraint.constant - 48
//        }
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
        
        let tf: UITextField = phoneTextFieldView.textField

        tf.attributedText = mas

        if let targetPosition = tf.position(from: tf.beginningOfDocument, offset: cs.caretOffset) {
            tf.selectedTextRange = tf.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func enableSubmitButton() {
        
        signUpButton.enbaleButton()
    }
    
    func disableSubmitButton() {
        signUpButton.disableButton()
        
    }
    func setSelectedFilter(_ filter: SignType) {
        DispatchQueue.main.async {
            self.signTypeCollectionView.updateSelected(filter)
        }
    }
    
    func setPhoneIsConfirmable(_ isConfirmable: Bool) {
        phoneTextFieldView.setConfirmButtonEnabled(isConfirmable)
    }
    
    
    func setup() {
        setupAgeRestrictionTextView()
        setupSignTypeCollectionView()
    }
    
    func setupSignTypeCollectionView() {
        let collection = SignTypeCollectionView()
        
        collection.isSkeletonable = true
        
        signTypeCollectionView = collection
        view.addSubview(signTypeCollectionView)
        signTypeCollectionView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(94)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    func setupAgeRestrictionTextView() {
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = R.font.lato_BBRegular(size: 13)
        textView.isUserInteractionEnabled = true
        
        textView.linkTextAttributes = [.foregroundColor: UIColor(hex: 0xFFFFFF)]
        let mas = NSMutableAttributedString(string: "Подтверждаю, что мне больше 18 лет, а также ознакомлен и согласен со всеми установленными букмекерской конторой правилами и положениями. ", attributes: [
                .foregroundColor: UIColor(hex: 0x989FAB)
            ])
        mas.append(NSAttributedString(string: "Подробнее", attributes: [
            .link: "https://betboom.ru/pages/agreement?webview=1"
        ]))
        mas.append(NSAttributedString(string: " "))
        textView.attributedText = mas
        textView.textContainerInset =  .zero
        textView.textContainer.lineFragmentPadding = 0
        
//        stackView.addSubview(self.textView)
//        textView.snp.makeConstraints { make in
//            make.leading.equalTo(checkBox.snp.trailing).offset(12)
//            make.top.equalTo(stackView.snp.bottom).offset(24)
//            make.height.equalTo(74)
//            make.trailing.equalToSuperview().offset(28)
//        }
    }
    
    @IBAction func phoneDidTapRemove(_ sender: UIButton) {
        phoneTextFieldView.textField.text = ""
    }
    
    @IBAction func passwordDidTapRemove(_ sender: UIButton) {
        passwordTextFieldView.textField.text = ""
    }
    
    
    @IBAction func didTapCheckBox(_ sender: BBCheckBox) {
        checkBox.isSelected.toggle()
        presenter?.updateSubmitButton()
    }
    
    @IBAction func captchDidTapRemove(_ sender: Any) {
//        captchaTextField.text = ""
    }
    
    func updateCaptcha(isEnabled: Bool, data: String) {
        self.capchaIsEnabled = isEnabled
        if !isEnabled{
            catpchaView.isHidden = true
//            stackViewHeightConstraint.constant = stackViewHeightConstraint.constant - 48
        }else{
            captchaImageView.image = UIImage(base64: data)
            catpchaView.isHidden = false
        }
        
    }
    
    @IBAction func didTapRepeatButton(_ sender: UIButton) {
        presenter?.didTapRepeatCaptcha()
    }
    
    func showCheckSmsController(sessionId: String) {
        let phone = phoneTextFieldView.textField.text ?? ""
        let vc = CheckSmsViewController(phoneNumber: phone, sessionId: sessionId, isRecovery: false)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didClickSign(_ sender: UIButton) {
        let phone = phoneTextFieldView.textField.text ?? ""
        let password = passwordTextFieldView.textField.text ?? ""
        let gambler = Gambler(phone: phone, password: password)
        if currentType == .signUp{
       
            presenter?.didTapSignUp(gambler: gambler)
        }else{
            presenter?.didTapSignIn(gambler: gambler)
        }
     
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkboxIsChecked() -> Bool {
        return checkBox.isSelected
    }
    
    @objc func tapClearPhone() {
        presenter?.didClearPhone()
    }
    
    
    @IBAction func didTapForgetPassword(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

 class NonSelectableTextViewWithTappableLink: UITextView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
}
