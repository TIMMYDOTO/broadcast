//
//  BBField.swift
//  BingoBoom
//
//  Created by Шкёпу Артём Вячеславович on 15.07.2020.
//  Copyright © 2020 BingoBoom. All rights reserved.
//

import UIKit
import SwiftTheme

protocol BBFieldProtocol: class {
    func didChangeStatus(status: Bool)
}

class BBField: UIView {
    
    var errorMessage: String!
    var minimumCount: Int!
    
    var textField = UITextField()
    weak var delegate: BBFieldProtocol?
    var label = UILabel()
    var redLine = UIImageView()
    var errorLabel = UILabel()
    let fieldHeight: CGFloat = 48.0
    let backgroundView = UIView()
    
    
    @IBInspectable var title: String = "" {
        didSet{
            label.text = title
        }
    }
    
    @IBInspectable var isValidated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
        
    }
    
    func setupView(){
        backgroundColor = .clear
        backgroundView.theme_backgroundColor = ThemeColor.backgroundAdditional
        addSubview(backgroundView)
        backgroundView.layer.cornerRadius = 4
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.tintColor = Colors.mainYellowColor
        textField.theme_textColor = ThemeColor.textPrimary
        
        let font = UIFont(name: "Lato_BB-Regular", size: 14)
        
        textField.font = font
        textField.autocorrectionType = .no
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 30, height: fieldHeight)
        textField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        addSubview(textField)
        
        
        label.frame = CGRect(x: 12, y: 14, width: self.frame.size.width, height: 20)
        label.text = title
        label.theme_textColor = ThemeColor.textAdditional
        label.font = font
        label.isAccessibilityElement = false
        
        addSubview(label)
        
        
        
        errorLabel.frame = CGRect(x: 0, y: fieldHeight + 5, width: bounds.width, height: font!.lineHeight)
        errorLabel.font = font
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.textColor = Colors.mainRedColor
        addSubview(errorLabel)
        
        
//        redLine.image = #imageLiteral(resourceName: "Error")
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: fieldHeight)
        redLine.frame = CGRect(x: -0.5, y: 40.5, width: frame.size.width + 0.5, height: 9)
        errorLabel.frame = CGRect(x: 0, y: fieldHeight + 5, width: frame.size.width, height: errorLabel.font.lineHeight)
    }
    
    @objc func textFieldDidBegin(){
        if errorLabel.text != Self.forbiddenSymbolErrorMessage {
            removeError()
        }
        if textField.text!.isEmpty {
            movePlaceHolderTop()
        }
    }
    
    @objc func textFieldDidEnd() {
        
        if textField.text!.isEmpty {
            movePlaceHolderCenter()
        }
    }
    
    
    func movePlaceHolderTop() {
        self.label.alpha = 0.0
        self.textField.frame = CGRect(x: 0, y: 18, width: self.frame.size.width - 30, height: 30)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: ({
            
            self.label.frame = CGRect(x: 12, y: 0, width: self.frame.size.width, height: 24)
            
            self.label.font = self.label.font.withSize(10)
            self.label.alpha = 1.0
            
        }))
    }
    
    func movePlaceHolderCenter() {
        self.label.alpha = 0.0
        self.textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 30, height: self.frame.size.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: ({
            
            self.label.frame = CGRect(x: 12, y: 14, width: self.frame.size.width, height: 20)
            self.label.font = self.label.font.withSize(14)
            self.label.alpha = 1.0
            
        }))
    }
    
    
    private func getHeightConstraint() -> NSLayoutConstraint? {
        return constraints.filter {
            if $0.firstAttribute == .height, $0.relation == .equal, $0.firstItem === self {
                return true
            }
            return false
        }.first
    }
    
    func updateStatus(message: String) {
        
        if !message.isEmpty {
            isValidated = false
            delegate?.didChangeStatus(status: isValidated)

            if !textField.isEditing {
                addError(message: message)
            }

        }else{
            isValidated = true
            delegate?.didChangeStatus(status: isValidated)
            removeError()
        }
    }
    
    enum Status {
        case ok
        case error
        case errorMessage(String)
        case forbiddenSymbolError
    }
    
    static let forbiddenSymbolErrorMessage = "Недопустимый символ"
    
    func setStatus(_ status: Status) {
        switch status {
        case .ok:
            isValidated = true
            delegate?.didChangeStatus(status: isValidated)
            removeError()
        case .error:
            isValidated = false
            delegate?.didChangeStatus(status: isValidated)
            if !textField.isEditing {
                addError()
            }
        case .errorMessage(let message):
            isValidated = false
            delegate?.didChangeStatus(status: isValidated)
            if !textField.isEditing {
                addError(message: message)
            } else {
                removeError()
            }
        case .forbiddenSymbolError:
            isValidated = false
            delegate?.didChangeStatus(status: isValidated)
            addError(message: Self.forbiddenSymbolErrorMessage)
        }
    }
    
    func addError(message: String? = nil) {
        backgroundView.addSubview(redLine)
        if let message = message {
            errorLabel.text = message
            errorLabel.accessibilityIdentifier = (textField.accessibilityIdentifier ?? "TextInput") + ".ErrorMessage"
            let height = fieldHeight + errorLabel.bounds.size.height
            
            if let constraint = getHeightConstraint(), constraint.constant < height {
                UIView.animate(withDuration: 0.6) {
                    constraint.constant = height
                    self.superview?.layoutIfNeeded()
       
                }
                
                delegate?.didChangeStatus(status: isValidated)
                
            }
        }
    }
    
    func removeError() {
        if redLine.superview != nil {
            redLine.removeFromSuperview()
        }
        if let constraint = getHeightConstraint(), constraint.constant > fieldHeight {
            UIView.animate(withDuration: 0.4, animations: {
                constraint.constant = self.fieldHeight
                self.errorLabel.text = ""
                self.window?.layoutIfNeeded()
            })
        }
    }
    func addPainCheck() {
        textField.addTarget(self, action: #selector(moneyIsEditing), for: .editingChanged)
    }
    
    @objc func moneyIsEditing() {
        let errorMsg = check(textField: textField)
        updateStatus(message: errorMsg)
    }
    
    func check(textField: UITextField) -> String {
        return textField.text!.digits.count < minimumCount ? errorMessage : ""
    }
    
}
