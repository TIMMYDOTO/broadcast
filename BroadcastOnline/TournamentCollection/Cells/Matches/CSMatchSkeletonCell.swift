//
//  CSMatchSkeletonCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 27.04.2022.
//

import UIKit
import SwiftTheme

class CSMatchSkeletonCell: UICollectionViewCell {
    
    private weak var firstIconSkeleton: UIView!
    private weak var firstTitleSkeleton: UIView!
    
    private weak var secondIconSkeleton: UIView!
    private weak var secondTitleSkeleton: UIView!
    
    private weak var subtitleSkeleton: UIView!
    
    private weak var stakeContainerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CSMatchSkeletonCell {
    func setup() {
        setupView()
        setupStakeContainerView()
        setupStakeSkeleton(trailing: 21)
        setupStakeSkeleton(trailing: -45)
        setupStakeSkeleton(trailing: -111)
        setupFirstTitleSkeleton()
        setupSecondTitleSkeleton()
        setupSubtitleSkeleton()
    }
    
    func setupView() {
        isSkeletonable = true
        contentView.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#F6F7FB")
        
        let bottomView = UIView()
        bottomView.theme_backgroundColor = ThemeColorPicker(colors: "#0D0D0D", "#FFFFFF")
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    func setupStakeContainerView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.isSkeletonable = true
        
        stakeContainerView = container
        contentView.addSubview(stakeContainerView)
        stakeContainerView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(175)
        }
    }
    
    func setupStakeSkeleton(trailing: CGFloat) {
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#212121", "#D2D5E0")
        view.isSkeletonable = true
        view.skeletonCornerRadius = 8
        
        stakeContainerView.addSubview(view)
        view.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(72)
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(trailing)
        }
        
        let title = UIView()
        title.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#F6F7FB")
        title.layer.cornerRadius = 3
        
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(29)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(6)
            $0.width.equalTo(41)
        }
        
        let coef = UIView()
        coef.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#F6F7FB")
        coef.layer.cornerRadius = 3
        
        contentView.addSubview(coef)
        coef.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(6)
            $0.width.equalTo(26)
        }
    }
    
    func setupFirstTitleSkeleton() {
        let icon = UIView()
        icon.isSkeletonable = true
        icon.layer.cornerRadius = 12
        icon.clipsToBounds = true
        
        firstIconSkeleton = icon
        contentView.addSubview(firstIconSkeleton)
        firstIconSkeleton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        firstTitleSkeleton = view
        contentView.addSubview(firstTitleSkeleton)
        firstTitleSkeleton.snp.makeConstraints {
            $0.leading.equalTo(firstIconSkeleton.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualTo(stakeContainerView.snp.leading).offset(-16).priority(.high)
            $0.centerY.equalTo(firstIconSkeleton.snp.centerY)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(104)
        }
    }
    
    func setupSecondTitleSkeleton() {
        let icon = UIView()
        icon.isSkeletonable = true
        icon.layer.cornerRadius = 12
        icon.clipsToBounds = true
        
        secondIconSkeleton = icon
        contentView.addSubview(secondIconSkeleton)
        secondIconSkeleton.snp.makeConstraints {
            $0.top.equalTo(firstIconSkeleton.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        secondTitleSkeleton = view
        contentView.addSubview(secondTitleSkeleton)
        secondTitleSkeleton.snp.makeConstraints {
            $0.leading.equalTo(secondIconSkeleton.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualTo(stakeContainerView.snp.leading).offset(-16).priority(.high)
            $0.centerY.equalTo(secondIconSkeleton.snp.centerY)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(104)
        }
    }
    
    func setupSubtitleSkeleton() {
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        subtitleSkeleton = view
        contentView.addSubview(subtitleSkeleton)
        subtitleSkeleton.snp.makeConstraints {
            $0.top.equalTo(secondIconSkeleton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(8)
            $0.width.equalTo(98)
        }
    }
}
