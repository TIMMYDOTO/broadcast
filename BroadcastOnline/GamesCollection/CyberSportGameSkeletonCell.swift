//
//  CyberSportGameSkeletonCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 27.04.2022.
//

import UIKit

class CyberSportGameSkeletonCell: UICollectionViewCell {
    
    private weak var sportIconSkeleton: UIView!
    private weak var titleLabelSkeleton: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 0.50446648)
        layer.borderWidth = 2
        layer.cornerRadius = 8
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CyberSportGameSkeletonCell {
    func setup() {
        setupSportIconSkeleton()
        setupTitleLabelSkeleton()
    }
    
    func setupSportIconSkeleton() {
        let icon = UIView()
        icon.isSkeletonable = true
        icon.layer.cornerRadius = 8
        icon.clipsToBounds = true
        
        sportIconSkeleton = icon
        contentView.addSubview(sportIconSkeleton)
        sportIconSkeleton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.height.width.equalTo(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabelSkeleton() {
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        titleLabelSkeleton = view
        contentView.addSubview(titleLabelSkeleton)
        titleLabelSkeleton.snp.makeConstraints {
            $0.top.equalTo(sportIconSkeleton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(51)
        }
    }
}
