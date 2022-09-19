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
            theme_backgroundColor = ThemeColorPicker(colors: "#FFFFFF", "#EDEEF2")
            titleLabel.theme_textColor = ThemeColorPicker(colors: UIColor.black, UIColor.black)
        } else {
            theme_backgroundColor = ThemeColorPicker(colors: UIColor.clear, UIColor.clear)
            titleLabel.theme_textColor = ThemeColorPicker(colors: "#CCCCCC", "#737373")
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
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
