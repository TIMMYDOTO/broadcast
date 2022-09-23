//
//  CSMatchSkeletonCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 27.04.2022.
//

import UIKit
import SkeletonView

class CSMatchSkeletonCell: UICollectionViewCell {
    
    private weak var firstIconSkeleton: UIView!
    private weak var firstTitleSkeleton: UIView!
    
    private weak var secondIconSkeleton: UIView!
    private weak var secondTitleSkeleton: UIView!
    private weak var mainView: UIView!
    private weak var subtitleSkeleton: UIView!

    let darkBlueGradient = SkeletonGradient(baseColor: #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1))
    private weak var stakeContainerView: UIView!
    private weak var timeTitleSkeleton: UIView!
    private weak var dateTitleSkeleton: UIView!
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
        setupMainView()
      
        setupStakeContainerView()
        let width = stakeContainerView.frame.size.width * 0.26
        setupStakeSkeleton(leading: 0)
//        setupStakeSkeleton(leading: 33 + width + 8)
//        setupStakeSkeleton(leading: 33 * 2 + width * 2 + 8 * 2)
        setupFirstTitleSkeleton()
        setupSecondTitleSkeleton()
        setupTimeTitleSkeleton()
        setupDateTitleSkeleton()
    }
    
    
    
    func setupMainView() {
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 16
        view.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1137254902, blue: 0.1607843137, alpha: 1)
        
        
        mainView = view
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview()
            
        }
    }
    
    func setupTimeTitleSkeleton() {
        let view = UIView()
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4

        
        timeTitleSkeleton = view
       
      

        timeTitleSkeleton.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        
        
        
        mainView.addSubview(timeTitleSkeleton)
        
        timeTitleSkeleton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-56)
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(40)
        }
    }
    
    
    func setupDateTitleSkeleton() {
        let view = UIView()
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4
        
        
        dateTitleSkeleton = view
        dateTitleSkeleton.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        mainView.addSubview(dateTitleSkeleton)
        
        dateTitleSkeleton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-56)
            $0.top.equalTo(timeTitleSkeleton.snp.bottom).offset(18)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(40)
        }
    }
    
    
    func setupView() {
        isSkeletonable = true
//        contentView.isSkeletonable = true
 

    }
    
    func setupStakeContainerView() {
        let container = UIView()
        
        container.isSkeletonable = true
        
        stakeContainerView = container
        
        mainView.addSubview(stakeContainerView)
        
        stakeContainerView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setupStakeSkeleton(leading: CGFloat) {
        let view = UIView()
        
        view.isSkeletonable = true
        view.skeletonCornerRadius = 8
        
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
        
        
        
        stakeContainerView.addSubview(view)
        view.snp.makeConstraints {
            $0.width.equalTo(stakeContainerView.snp.width).offset(-16).multipliedBy(0.33)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(leading)
        }
        
        let title = UIView()
        title.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        title.layer.cornerRadius = 3
        
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(8)
            $0.width.equalTo(21)
        }
        
        let coef = UIView()
        coef.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        coef.layer.cornerRadius = 3
        
        view.addSubview(coef)
        coef.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(8)
            $0.width.equalTo(40)
        }
    }
    
    func setupFirstTitleSkeleton() {
        
        let view = UIView()
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4
        
        
        firstTitleSkeleton = view
        firstTitleSkeleton.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        mainView.addSubview(firstTitleSkeleton)
        
        firstTitleSkeleton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(33)
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(128)
        }
    }
    
    func setupSecondTitleSkeleton() {

//
        let view = UIView()
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4
        
        view.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        secondTitleSkeleton = view
        secondTitleSkeleton.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        mainView.addSubview(secondTitleSkeleton)
        secondTitleSkeleton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(33)
            
            $0.top.equalToSuperview().offset(50)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(128)
        }
    }
    
    
}
