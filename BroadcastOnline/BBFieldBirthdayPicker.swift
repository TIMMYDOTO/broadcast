//
//  BBFieldDatePicker.swift
//  BetBoom
//
//  Created by Шкёпу Артём Вячеславович on 10.12.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import UIKit

class BBFieldBirthdayPicker: BBField {
    
    var didEndEditing: (() -> Void)?
    
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setup()
    }
    
    
    func setup() {
        textField.delegate = self
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
            
        textField.inputView = datePicker
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)

    }
    
    @objc func editingDidEnd() {
//        if isValidated {
            if textField.text!.isEmpty{
                updateStatus(message: "Обязательное поле")
            }else{
                updateStatus(message: "")
            }
//        }
    }
    
    @objc  func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd.MM.yyyy"
        textField.text = dateFormatter.string(from: sender.date)
        self.movePlaceHolderTop()
        if textField.text!.isEmpty{
            updateStatus(message: "Обязательное поле")
        }else{
            updateStatus(message: "")
        }
    }
}

extension BBFieldBirthdayPicker: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
}
