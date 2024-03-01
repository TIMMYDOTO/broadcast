//
//  SMSPlaceholder.swift
//  Cyber Live
//
//  Created by Vitaliy Kozlov on 22.02.24.
//

import UIKit
import SwiftTheme

final class SmsPlaceholderView: UIView {
    
    private weak var gradientView: UIView!
    private weak var animationView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var backButton: UIButton!
    
    var onPop: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // let colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        backButton.applyGradientRedrow(colors: [UIColor(hex: "#FF4E4E")!, UIColor(hex: "#FF834E")!])
        self.applyGradientRedrow(colors:  [UIColor(hex: "#0D1017")!, UIColor(hex: "#1C2230")!], startPoint: CGPoint(x: 0.5, y: 0), endPoint:CGPoint(x: 0.5, y: 1))
    }
    
    func play() {
//        animationView.play()
    }
    
    func pause() {
//        animationView.pause()
    }
}

private extension SmsPlaceholderView {
    func setup() {
        backgroundColor = UIColor(hex: "#0D1017")
        setupAnimationView()
        setupTitleLabel()
        setupButton()
    }
    
    func setupAnimationView() {
        let anim = UIImageView()
        anim.image = UIImage(named: "handImg")
        
        animationView = anim
        addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
            $0.centerY.equalToSuperview().offset(-36)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.robotoBold(size: 32)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.alignment = .center
        let error = "Превышено число\nпопыток ввода смс"
        label.attributedText = NSMutableAttributedString(
            string: error,
            attributes: [.kern: 0.26, .paragraphStyle: paragraphStyle]
        )
        
        titleLabel = label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupButton() {
        let v = UIButton()
        v.setTitle("Вернуться назад", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font =  R.font.robotoBold(size: 16)
        v.layer.cornerRadius = 16
        v.backgroundColor = .clear
        backButton = v
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-26)
        }
        
    }
    
    @objc private func handleBackButtonTap() {
        onPop?()
    }
    
}


extension UIView {
    func applyGradientRedrow(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.name = "backgroundGradient"

        // Удаление существующего градиента, если он есть
        if let oldLayer = self.layer.sublayers?.first(where: { $0.name == "backgroundGradient" }) {
            oldLayer.removeFromSuperlayer()
        }

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds = true

        // Обновление слоя при изменении размеров
        if let action = self.action(for: layer, forKey: "bounds.size") {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                gradientLayer.frame = self.bounds
            }
            action.run(forKey: "bounds.size", object: self.layer, arguments: nil)
            CATransaction.commit()
        }
    }
}
