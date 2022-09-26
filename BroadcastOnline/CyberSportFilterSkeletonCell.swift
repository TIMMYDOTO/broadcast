//
//  CyberSportFilterSkeletonCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import UIKit
import SkeletonView
class CyberSportFilterSkeletonCell: UICollectionViewCell {
   
    private weak var titleLabelSkeleton: UIView!
    private weak var blueBackgroundView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

 extension CyberSportFilterSkeletonCell {
    func setup() {
        setupBackgroundView()
        setupSkeletonTitleView()
    }
    
    func setupBackgroundView() {
        print("setupBackgroundView")
        let view = UIView()
//        view.isSkeletonable = true
//        view.skeletonCornerRadius = 12
  
        blueBackgroundView = view
//        blueBackgroundView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2862745098, alpha: 1)
        
//        blueBackgroundView.showAnimatedSkeleton(usingColor: #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1))

        contentView.addSubview(blueBackgroundView)
        blueBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(36)
            
        }

    }
    
    func addBackground() {
        
        print("addBackground")
        blueBackgroundView.layer.cornerRadius = 12
        blueBackgroundView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2862745098, alpha: 1)
//        blueBackgroundView.showGradientSkeleton(usingGradient: skeletonGradiend, transition: .crossDissolve(0.25))
        titleLabelSkeleton.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1254901961, blue: 0.1803921569, alpha: 1)
    }
     
     func removeBackground() {
         print("removeBackground")
         blueBackgroundView.backgroundColor = .clear
         titleLabelSkeleton.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2235294118, blue: 0.3098039216, alpha: 1)
     }
    
    
    func setupSkeletonTitleView() {
        let view = UIView()

        view.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1254901961, blue: 0.1803921569, alpha: 1)
        view.layer.cornerRadius = 4
        titleLabelSkeleton = view
        blueBackgroundView.addSubview(titleLabelSkeleton)
       
        titleLabelSkeleton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(8)
            
        }

    }
}
