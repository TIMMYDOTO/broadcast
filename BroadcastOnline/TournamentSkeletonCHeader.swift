//
//  TournamentSkeletonCHeader.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.07.2021.
//

import UIKit
import SwiftTheme

class TournamentSkeletonCHeader: UICollectionReusableView {
    
    private weak var containerView: UIView!
    private weak var titleLabelSkeleton: UIView!
    private weak var countViewSkeleton: UIView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TournamentSkeletonCHeader {
    func setup() {
        setupView()
        setupTitleLabelSkeleton()
        setupCountViewSkeleton()
    }
    
    func setupView() {
        isSkeletonable = true
        
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#212121", "#EDEEF2")

        containerView = view
        addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTitleLabelSkeleton() {
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#D2D5E0")
        view.isSkeletonable = true
        view.skeletonCornerRadius = 3
        
        titleLabelSkeleton = view
        addSubview(titleLabelSkeleton)
        titleLabelSkeleton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(19)
            $0.height.equalTo(6)
            $0.width.equalTo(115)
        }
    }
    
    func setupCountViewSkeleton() {
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#D2D5E0")
        view.isSkeletonable = true
        view.skeletonCornerRadius = 4
        
        countViewSkeleton = view
        addSubview(countViewSkeleton)
        countViewSkeleton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(16)
            $0.width.equalTo(24)
        }
    }
}
