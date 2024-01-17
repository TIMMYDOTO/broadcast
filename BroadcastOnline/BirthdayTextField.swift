//
//  BirthdayTextField.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 21.12.2023.
//

import UIKit

class BirthdayTextField: UIView {
    
    var didBecomeFirstResponder: ((BirthdayTextField) -> Void)?
    
    var didResignFirstResponder: ((BirthdayTextField) -> Void)?
    var backgroundView: UIView!
    
    var textField: UITextField!
    var errorLabel: UILabel!
    var datePicker: UIDatePicker!
    
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
    
    
    func setup() {
        setupBackgroundView()
        setupDatePicker()
        setupTextField()
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
    
    func setupDatePicker() {
        let dtPicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            dtPicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    
        dtPicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        dtPicker.datePickerMode = .date
        dtPicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
        
        datePicker = dtPicker
    }
    
    private func setupTextField() {
        let tf = UITextField()
        tf.tintColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0.3058823529, alpha: 1)
        tf.textColor = .white
        tf.font = R.font.lato_BBRegular(size: 16)
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
//        tf.isUserInteractionEnabled = false
        
//        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
//        tf.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        tf.inputView = datePicker
        backgroundView.addSubview(tf)
        tf.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(56)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-56)
            $0.height.equalTo(24)
        }
        
        self.textField = tf
    }
    
    @objc func didEndEditing() {
        
        if textField.text!.isEmpty{
            //                updateStatus(message: "Обязательное поле")
        }else{
            //                updateStatus(message: "")
        }
        
    }
    
    @objc  func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd.MM.yyyy"
        textField.text = dateFormatter.string(from: sender.date)
      
        if textField.text!.isEmpty{
//            updateStatus(message: "Обязательное поле")
        }else{
//            updateStatus(message: "")
        }
    }
    
    
}
