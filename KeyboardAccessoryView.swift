//
//  AuthKeyboardAccessoryView.swift
//  BetBoom
//
//  Created by Владимир Занков on 02.01.2023.
//

import UIKit
import SwiftTheme

class AuthKeyboardAccessoryView: UIView {
    
    var didTapSubmitButton: (() -> Void)?
    
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupButton()
        setButtonEnabled(false)
        
        theme_backgroundColor = ThemeColorPicker(colors: "#1F1F1F", "#EDEEF2")
    }
    
    private func setupButton() {
        let b = UIButton()
        b.titleLabel?.font = R.font.lato_BBBold(size: 16)
        b.theme_setTitleColor(ThemeColorPicker(colors: "#0D0D0D", "#0D0D0D"), forState: .normal)
        b.theme_setTitleColor(ThemeColorPicker(colors: "#CCCCCC", "#0D0D0D"), forState: .disabled)
        b.layer.cornerRadius = 16
        b.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        addSubview(b)
        b.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        self.button = b
    }
    
    @objc func tapSubmit() {
        didTapSubmitButton?()
    }
    
    func setButtonEnabled(_ isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.theme_backgroundColor = isEnabled ? .init(colors: "#F8E800", "#F8E800") : .init(colors: "#737373", "#D2D5E0")
    }
}
