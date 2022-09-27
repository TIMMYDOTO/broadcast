//
//  CyberSportPlaceholderView.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 20.05.2022.
//

import UIKit

import SwiftTheme

class CyberSportPlaceholderView: UIView {
    
    private weak var animationView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var subTitleLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
//        animationView.play()
    }
    
    func pause() {
//        animationView.pause()
    }
}

private extension CyberSportPlaceholderView {
    func setup() {
        setupAnimationView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupAnimationView() {
        let anim = UIImageView()
        
        
        
        anim.image = UIImage(named: "smile")
        
        animationView = anim
        addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.robotoBold(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.alignment = .center
        let noMatches = NSLocalizedString("LiveIsEmpty", comment: "NoMatches Title")
        label.attributedText = NSMutableAttributedString(
            string: noMatches,
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
    
    func setupSubtitleLabel() {
        let label = UILabel()
        let noMatches = NSLocalizedString("FollowForPrematch", comment: "NoMatches Title")
        label.textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.5041179531)
        label.text = noMatches
        label.textAlignment = .center
        subTitleLabel = label
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}
