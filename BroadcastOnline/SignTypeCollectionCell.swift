//
//  SignTypeCollectionCell.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 01.12.2023.
//

import UIKit

class SignTypeCollectionCell: UICollectionViewCell {
    private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ value: SignType, selected: Bool) {
        let model = value.getModel()
        titleLabel.text = model.title
        clipsToBounds = true
        if selected {
            let firstColor = #colorLiteral(red: 0.5158827305, green: 0.6132621169, blue: 0.8050376773, alpha: 1)
            let secondColor = #colorLiteral(red: 0.3490196078, green: 0.3647058824, blue: 0.6941176471, alpha: 1)
            applyGradient(isVertical: true, colorArray: [firstColor, secondColor])
            titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            titleLabel.font = R.font.robotoBold(size: 12)
        } else {
            titleLabel.font = R.font.robotoBold(size: 12)
            let firstColor = UIColor.clear
            let secondColor = UIColor.clear
            
            applyGradient(isVertical: true, colorArray: [firstColor, secondColor])
            titleLabel.textColor = #colorLiteral(red: 0.5843137255, green: 0.7176470588, blue: 1, alpha: 1)
        }
    }
    
    func prepareForSkeleton() {
        titleLabel.text = "testmessage"
    }
    
}

private extension SignTypeCollectionCell {
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
