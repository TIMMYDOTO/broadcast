//
//  CyberSportFilterCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 28.03.2022.
//

import UIKit
import SwiftTheme

class CyberSportFilterCell: UICollectionViewCell {
    
    private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ value: CSFilter, selected: Bool) {
        let model = value.getModel()
        titleLabel.text = model.title
        
        if selected {
            backgroundColor = .white
            titleLabel.textColor = #colorLiteral(red: 0.1402209699, green: 0.1697322726, blue: 0.2372379601, alpha: 1)
            titleLabel.font = R.font.robotoBold(size: 12)
        } else {
            titleLabel.font = R.font.robotoBold(size: 12)
            backgroundColor = .clear
            titleLabel.textColor = .white
        }
    }
    
    func prepareForSkeleton() {
        titleLabel.text = "testmessage"
    }
    
}

private extension CyberSportFilterCell {
    func setup() {
        setupCell()
        setupTitleLabel()
    }
    
    func setupCell() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.font = R.font.lato_BBRegular(size: 12)
        
        titleLabel = label
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}
