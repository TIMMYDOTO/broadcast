//
//  CyberSportPlaceholderView.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 20.05.2022.
//

import UIKit
import Lottie
import SwiftTheme

class CyberSportPlaceholderView: UIView {
    
    private weak var animationView: AnimationView!
    private weak var titleLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        animationView.play()
    }
    
    func pause() {
        animationView.pause()
    }
}

private extension CyberSportPlaceholderView {
    func setup() {
        setupAnimationView()
        setupTitleLabel()
    }
    
    func setupAnimationView() {
        let anim = AnimationView()
        let animation = Animation.named("illustration_7")
        anim.animation = animation
        anim.contentMode = .scaleAspectFit
        anim.loopMode = .autoReverse
        
        animationView = anim
        addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.height.equalTo(280)
            $0.width.equalTo(340)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        label.font = R.font.gilroy_BBBold(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(
            string: "Нет событий",
            attributes: [.kern: 0.26, .paragraphStyle: paragraphStyle]
        )
        
        titleLabel = label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
