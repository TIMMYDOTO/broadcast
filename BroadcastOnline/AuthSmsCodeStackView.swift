//
//  AuthSmsCodeStackView.swift
//  BetBoom
//
//  Created by Владимир Занков on 06.01.2023.
//

import UIKit
import SwiftTheme

class AuthSmsCodeStackView: UIStackView {
    
    private let length: Int
    private var labels: [UILabel] = []
    
    init(length: Int, frame: CGRect) {
        self.length = length
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .horizontal
        spacing = 4
        distribution = .fillEqually
        
        setupLabels()
    }
    
    private func setupLabels() {
        for _ in 0 ..< length {
            let l = UILabel()
            l.textAlignment = .center
            l.textColor = .white
            l.layer.cornerRadius = 16
            l.layer.borderWidth = 1
            l.layer.borderColor = #colorLiteral(red: 0.2913191915, green: 0.3439336419, blue: 0.4444465041, alpha: 1)
            l.text = "•"
            l.font = R.font.giorgioSansLCGBold(size: 40)
            l.clipsToBounds = true
            l.snp.makeConstraints {
                $0.width.equalTo(51)
                $0.height.equalTo(56)
            }
            addArrangedSubview(l)
            labels.append(l)
        }
    }
    
    func setCode(_ code: String) {
        let padded = code.padding(toLength: length, withPad: "•", startingAt: 0)
        for (i, s) in padded.enumerated() {
            let l = labels[i]
            l.text = String(s)
            let firstColor = #colorLiteral(red: 0.3176470588, green: 0.3803921569, blue: 0.5411764706, alpha: 0)
            let secondColor = #colorLiteral(red: 0.2039215686, green: 0.2431372549, blue: 0.3411764706, alpha: 1)
            if  s == "•" {
                l.backgroundColor = .clear
            }else{
                l.applyGradient(isVertical: true, colorArray: [firstColor, secondColor])
            }
                
            l.layer.theme_borderWidth = s == "•" ?
                .init(floats: 1, 1) :
                .init(floats: 1, 0)
        }
    }
}
