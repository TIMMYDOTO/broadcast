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
     
        setupStakeSkeleton()
//        setupStakeSkeleton(leading:stakeContainerView.snp.width)
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
    
    func setupStakeSkeleton() {
        let view = UIView()
        
        view.isSkeletonable = true
        view.layer.cornerRadius = 8
       
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
        
        
        
        stakeContainerView.addSubview(view)
        view.snp.makeConstraints {
            $0.width.equalTo(stakeContainerView.snp.width).multipliedBy(0.32)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        let title = UIView()
        title.isSkeletonable = true
        title.skeletonCornerRadius = 3
        title.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(8)
            $0.width.equalTo(21)
        }
        
        let coef = UIView()
        coef.isSkeletonable = true
        coef.skeletonCornerRadius = 3
        coef.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view.addSubview(coef)
        coef.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(8)
            $0.width.equalTo(40)
        }
        
        
        let view2 = UIView()
        
        view2.isSkeletonable = true
        view2.layer.cornerRadius = 8
       
        view2.layer.borderWidth = 2
        view2.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
        
        
        
        stakeContainerView.addSubview(view2)
        view2.snp.makeConstraints {
            $0.width.equalTo(stakeContainerView.snp.width).multipliedBy(0.32)
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
            $0.leading.equalTo(view.snp.trailing).offset(8)
        }
        
        let title2 = UIView()
        title2.isSkeletonable = true
        title2.skeletonCornerRadius = 3
        title2.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view2.addSubview(title2)
        title2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(8)
            $0.width.equalTo(21)
        }
        
        let coef2 = UIView()
        coef2.isSkeletonable = true
        coef2.skeletonCornerRadius = 3
        coef2.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view2.addSubview(coef2)
        coef2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(8)
            $0.width.equalTo(40)
        }
        
        
        let view3 = UIView()
        
        view3.isSkeletonable = true
        view3.layer.cornerRadius = 8
       
        view3.layer.borderWidth = 2
        view3.layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 1)
        
        
        
        stakeContainerView.addSubview(view3)
        view3.snp.makeConstraints {

            $0.height.equalTo(40)
            $0.top.equalToSuperview()
            $0.leading.equalTo(view2.snp.trailing).offset(8)
            $0.trailing.equalTo(stakeContainerView.snp.trailing)
        }
        
        let title3 = UIView()
        title3.isSkeletonable = true
        title3.skeletonCornerRadius = 3
        title3.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view3.addSubview(title3)
        title3.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(8)
            $0.width.equalTo(21)
        }
        
        let coef3 = UIView()
        coef3.isSkeletonable = true
        coef3.skeletonCornerRadius = 3
        coef3.showAnimatedGradientSkeleton(usingGradient: darkBlueGradient, transition: .crossDissolve(0.25))
        view3.addSubview(coef3)
        coef3.snp.makeConstraints {
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
            $0.leading.equalToSuperview().offset(17)
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
            $0.leading.equalToSuperview().offset(17)
            
            $0.top.equalToSuperview().offset(50)
            $0.height.equalTo(8)
            $0.width.lessThanOrEqualTo(128)
        }
    }
    
    
}
