//
//  AuthViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 30.11.2023.
//

import UIKit

class AuthViewController: UIViewController, AuthViewInput {

  
    @IBOutlet weak var phoneTextFieldView: PhoneTextField!{
        didSet{
            let gr = UITapGestureRecognizer()
            gr.addTarget(self, action: #selector(tapClearPhone))
            gr.cancelsTouchesInView = true
            phoneTextFieldView.rightView.addGestureRecognizer(gr)
            phoneTextFieldView.rightView.isUserInteractionEnabled = false
       
        }
    }
    
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
    @IBOutlet weak var passwordTextField: TextField!{
        didSet{
            passwordTextField.layer.borderWidth = 1.0
            passwordTextField.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7176470588, blue: 1, alpha: 1)
            passwordTextField.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!{
        didSet{
            phoneTextField.layer.borderWidth = 1.0
            phoneTextField.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
            phoneTextField.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4274509804, blue: 0.6, alpha: 1), for: .normal)
            signUpButton.layer.cornerRadius = 12
            signUpButton.clipsToBounds = true
     
        }
    }
    
    fileprivate weak var textView: NonSelectableTextViewWithTappableLink!
    private weak var signTypeCollectionView: SignTypeCollectionView!
    public var presenter: AuthPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
        setup()
        presenter.viewDidLoad()
        binding()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let firstColor = #colorLiteral(red: 0.1764705882, green: 0.2117647059, blue: 0.3019607843, alpha: 1)
        let secondColor = #colorLiteral(red: 0.1450980392, green: 0.1725490196, blue: 0.2392156863, alpha: 1)
        self.signUpButton.applyGradient(colours: [firstColor, secondColor])
    }
    
    func binding() {
        signTypeCollectionView.willSelect = { [weak self] type in
            self?.presenter?.changeCurrentSignType(type)
        }
        
        phoneTextFieldView.didChangeEditing = { [weak self] str in
            self?.presenter?.didChangeEditingPhone(str)
        }
    }
    
    func setClearPhoneButtonIsShown(_ isShown: Bool) {
        let img: UIImage? = isShown ? UIImage(named: "Close") : nil
        phoneTextFieldView.setRightImage(image: img, animated: true)
        phoneTextFieldView.rightView.isUserInteractionEnabled = isShown
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
        let tv = NonSelectableTextViewWithTappableLink()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.font = R.font.lato_BBRegular(size: 13)
        tv.isUserInteractionEnabled = true
        
        tv.linkTextAttributes = [.foregroundColor: UIColor(hex: 0xFFFFFF)]
        let mas = NSMutableAttributedString(string: "Подтверждаю, что мне больше 18 лет, а также ознакомлен и согласен со всеми установленными букмекерской конторой правилами и положениями. ", attributes: [
                .foregroundColor: UIColor(hex: 0x989FAB)
            ])
        mas.append(NSAttributedString(string: "Подробнее", attributes: [
            .link: "https://betboom.ru/pages/agreement?webview=1"
        ]))
        mas.append(NSAttributedString(string: " "))
        tv.attributedText = mas
        tv.textContainerInset =  .zero
        tv.textContainer.lineFragmentPadding = 0
        self.textView = tv
        view.addSubview(self.textView)
        textView.snp.makeConstraints { make in
            make.leading.equalTo(checkBox.snp.trailing).offset(12)
            make.top.equalTo(captchaTextField.snp.bottom).offset(24)
            make.height.equalTo(74)
            make.trailing.equalToSuperview().offset(28)
        }
    }
    
    @IBAction func phoneDidTapRemove(_ sender: UIButton) {
        phoneTextField.text = ""
    }
    
    @IBAction func passwordDidTapRemove(_ sender: UIButton) {
        passwordTextField.text = ""
    }
    
    
    @IBAction func didTapCheckBox(_ sender: BBCheckBox) {
        checkBox.isSelected.toggle()
    }
    
    @IBAction func captchDidTapRemove(_ sender: Any) {
//        captchaTextField.text = ""
    }
    
    func updateCaptcha(isEnabled: Bool, data: String) {
        
        captchaImageView.image = UIImage(base64: data)
    }
    
    @IBAction func didTapRepeatButton(_ sender: UIButton) {
        presenter?.didTapRepeatCaptcha()
    }
    
    
    @IBAction func didTapSign(_ sender: UIButton) {
        let phone = phoneTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let gambler = Gambler(phone: phone, password: password)
        presenter?.didTapSignUp(gambler: gambler)
    }
    
    @objc func tapClearPhone() {
        presenter?.didClearPhone()
    }
    
}

private class NonSelectableTextViewWithTappableLink: UITextView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
}
