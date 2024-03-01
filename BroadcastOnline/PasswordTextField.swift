//
//  PasswordTextField.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 04.12.2023.
//

import UIKit

class PasswordTextField: UIView {
    var didBecomeFirstResponder: ((PhoneTextField) -> Void)?
    
    var didResignFirstResponder: ((PhoneTextField) -> Void)?
    
    
    var didChangeEditing: ((CaretString) -> Void)?
    let fieldHeight: CGFloat = 48.0
    var textField: UITextField!
    var errorLabel: UILabel!
    var backgroundView: UIView!
    var maxLength: Int?
    var leftView: UIImageView!
    var rightView: UIImageView!
    var lastKnownKeyboardAnimationDuration = 0.25
    var lastKnownKeyboardAnimationOptions: UIView.AnimationOptions = []
    var placeholderLayer: CATextLayer!
    @IBInspectable var isValidated: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        
        
    }
    
    func setRightImage(image: UIImage?, animated: Bool) {
        
        guard animated else { rightView.image = image; return }
        UIView.transition(with: rightView, duration: lastKnownKeyboardAnimationDuration, options: lastKnownKeyboardAnimationOptions, animations: {
            self.rightView.image = image
        }, completion: nil)
    }
    
    func setup() {
        setupBackgroundView()
        setupLeftView()
        setupTextField()
        setupRightView()
        setupPlaceholderLayer()
        setupErrorLabel()
//        showErrorMessage("Минимум 8 символов")
    }
    
    func showErrorMessage(_ text: String) {
        errorLabel.text = text
        let d = lastKnownKeyboardAnimationDuration
        let b = CABasicAnimation(keyPath: "borderColor")
        b.fromValue = backgroundView.layer.borderColor
        b.toValue = UIColor(hex: 0xFF0025).cgColor
        b.duration = d
        backgroundView.layer.add(b, forKey: nil)
        backgroundView.layer.borderColor = UIColor(hex: 0xFF0025).cgColor
        
        UIView.animate(withDuration: d) {
            self.snp.updateConstraints {
                $0.height.equalTo(80)
            }
            self.errorLabel.alpha = 1
            self.textField.snp.updateConstraints {
                $0.top.equalToSuperview().offset(16)
            }
            self.window?.layoutIfNeeded()
        }
    }
    
    private func setupErrorLabel() {
        let l = UILabel()
//        l.text = "Обязательное поле"
        
        let font = UIFont(name: "Lato_BB-Regular", size: 14)
        l.frame = CGRect(x: 0, y: fieldHeight + 13, width: bounds.width, height: font!.lineHeight)
        l.font = font
        l.adjustsFontSizeToFitWidth = true
        l.textColor = #colorLiteral(red: 0.8980392157, green: 0.337254902, blue: 0.2784313725, alpha: 1)
        addSubview(l)
        
        self.errorLabel = l
    }
    
    
    private func setupPlaceholderLayer() {
        let l = CATextLayer()
        l.string = "Введи пароль *"
        l.font = R.font.robotoRegular(size: 14)
        l.fontSize = 14
        l.foregroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        l.contentsScale = UIScreen.main.scale
        layer.addSublayer(l)
        l.frame = CGRect(x: 56, y: 20, width: 183, height: 16)
        
        self.placeholderLayer = l
    }
    
    private func setupRightView() {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer()
        gr.addTarget(self, action: #selector(tapRevealPassword))
        gr.cancelsTouchesInView = true
        iv.addGestureRecognizer(gr)
        
        backgroundView.addSubview(iv)
        iv.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
        
        self.rightView = iv
    }
    
    @objc func tapRevealPassword() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let tmpImg = textField.isSecureTextEntry ? UIImage(named: "ShownPS") : UIImage(named: "hiddenPS")
        setRightImage(image: tmpImg, animated: true)
    }
    
    private func setupLeftView() {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = UIImage(named: "locker")
        iv.tintColor = #colorLiteral(red: 0.3490196078, green: 0.431372549, blue: 0.6, alpha: 1)
        backgroundView.addSubview(iv)
        iv.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
        
        self.leftView = iv
    }
    
    
    private func setupTextField() {
        let tf = UITextField()
        tf.tintColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0.3058823529, alpha: 1)
        tf.textColor = .white
        tf.font = R.font.lato_BBRegular(size: 16)
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tf.delegate = self
        tf.isSecureTextEntry = true
//        tf.isUserInteractionEnabled = false
        
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tf.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        backgroundView.addSubview(tf)
        tf.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(56)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-56)
            $0.height.equalTo(24)
        }
        
        self.textField = tf
    }
    
    @objc func didBeginEditing() {
        self.backgroundView.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7176470588, blue: 1, alpha: 1)
        let options = UIView.AnimationOptions.curveEaseIn.union(.beginFromCurrentState)
        animateViewsOnBecomingFirstResponder(duration: 0.25, options:options)
        updateStatus(message: "")
        self.leftView.tintColor = #colorLiteral(red: 0.5843137255, green: 0.7176470588, blue: 1, alpha: 1)
    }
    
    @objc func didEndEditing() {
        self.backgroundView.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.leftView.tintColor = #colorLiteral(red: 0.3490196078, green: 0.431372549, blue: 0.6, alpha: 1)
        let text = textField.text ?? ""
        if text.isEmpty {
            let options = UIView.AnimationOptions.curveEaseOut.union(.beginFromCurrentState)
            animateViewsOnResignFirstResponder(duration: 0.25, options:options)
            updateStatus(message: "Обязательное поле")
        }else {
            let errorMsg = hasError(textField: textField)
            updateStatus(message: errorMsg)
        }
    }
    
    
    func hasError(textField: UITextField) -> String {
        return textField.text!.count < 8 ? "Минимум 8 символов" : ""
    }
    
    func updateStatus(message: String) {
        
        if !message.isEmpty {
            isValidated = false
            if !textField.isEditing {
                addError(message: message)
            }

        }else{
            isValidated = true
            removeError()
        }
    }
    
    func removeError() {
//        if redLine.superview != nil {
//            redLine.removeFromSuperview()
//        }
        if let constraint = getHeightConstraint(), constraint.constant > fieldHeight {
            UIView.animate(withDuration: 0.4, animations: {
                constraint.constant = self.fieldHeight
                self.errorLabel.text = ""
//                self.window?.layoutIfNeeded()
            })
        }
    }
    
    func addError(message: String? = nil) {
        if let message = message {
            backgroundView.layer.borderColor = UIColor(hex: 0xE55647).cgColor
            errorLabel.text = message
            let height = fieldHeight + errorLabel.bounds.size.height
            
            if let constraint = getHeightConstraint(), constraint.constant < height {
                UIView.animate(withDuration: 0.6) {
                    constraint.constant = height
//                    self.superview?.layoutIfNeeded()
       
                }
                
            }
        }
    }
    
    
    private func getHeightConstraint() -> NSLayoutConstraint? {
        return constraints.filter {
            if $0.firstAttribute == .height, $0.relation == .equal, $0.firstItem === self {
                return true
            }
            return false
        }.first
    }
    
    
    private func animateViewsOnBecomingFirstResponder(duration: CGFloat, options: UIView.AnimationOptions) {

        let pf = CABasicAnimation(keyPath: #keyPath(CATextLayer.fontSize))
        pf.fromValue = self.placeholderLayer.fontSize
        pf.toValue = 10
        pf.duration = duration
        self.placeholderLayer.add(pf, forKey: nil)
        self.placeholderLayer.fontSize = 10
        
        let pp = CABasicAnimation(keyPath: "position.y")
        pp.fromValue = self.placeholderLayer.position.y
        pp.toValue = 6 + self.placeholderLayer.bounds.height / 2
        pp.duration = duration
        self.placeholderLayer.add(pp, forKey: nil)
        self.placeholderLayer.position.y = 6 + self.placeholderLayer.bounds.height / 2
    
        let oa = CABasicAnimation(keyPath: "opacity")
        oa.fromValue = self.placeholderLayer.opacity
        oa.toValue = 1
        oa.duration = duration
        self.placeholderLayer.add(oa, forKey: nil)
        self.placeholderLayer.opacity = 1
    
    }
    
    private func animateViewsOnResignFirstResponder(duration: CGFloat, options: UIView.AnimationOptions) {
        let pf = CABasicAnimation(keyPath: #keyPath(CATextLayer.fontSize))
        pf.fromValue = self.placeholderLayer.fontSize
        pf.toValue = 14
        pf.duration = duration
        self.placeholderLayer.add(pf, forKey: nil)
        self.placeholderLayer.fontSize = 14
        
        let pp = CABasicAnimation(keyPath: "position.y")
        pp.fromValue = self.placeholderLayer.position.y
        pp.toValue = 28
        pp.duration = duration
        self.placeholderLayer.add(pp, forKey: nil)
        self.placeholderLayer.position.y = 28
    
        let oa = CABasicAnimation(keyPath: "opacity")
        oa.fromValue = self.placeholderLayer.opacity
        oa.toValue = 1
        oa.duration = duration
        self.placeholderLayer.add(oa, forKey: nil)
        self.placeholderLayer.opacity = 1
    }
    
    @objc func editingChanged() {
        let text = textField.text ?? ""
        let tmpImg = textField.isSecureTextEntry ? UIImage(named: "ShownPS") : UIImage(named: "hiddenPS")
        let img: UIImage? = !text.isEmpty ? tmpImg : nil
        setRightImage(image: img, animated: true)
        let caretString = CaretString(string: text, caretPosition: text.index(text.startIndex, offsetBy: 0))
        
        didChangeEditing?(caretString)
        if !textField.isEditing {
//            didEndEditing?(text)
//            animateViewsOnResigningFirstResponder(
//                duration: 0.25, options: .curveEaseOut
//            )
        }
    }
    
    
    private func setupBackgroundView() {
        let v = UIView()
        v.backgroundColor = .clear
    
        v.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        v.tintColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        addSubview(v)
        v.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        self.backgroundView = v
    }
    
    func setConfirmButtonEnabled(_ isEnabled: Bool) {
        (textField.inputAccessoryView as? AuthKeyboardAccessoryView)?.setButtonEnabled(isEnabled)
    }
    
}



extension PasswordTextField : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let range = Range(range, in: text), let maxLength = maxLength {
            let newText = text.replacingCharacters(in: range, with: string)
            if newText.count > maxLength {
                return false
            }
        }
        return true
    }
}
