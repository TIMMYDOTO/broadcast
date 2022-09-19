//
//  CSMoreStakesCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SwiftTheme

protocol CSMoreStakesCellDelegate: AnyObject {
    
    func tapMore()
    
}

final class CSMoreStakesCell: UICollectionViewCell {
    
    private weak var mainView: UIView!
    private weak var titleLabel: UILabel!
    private weak var subtitleLabel: UILabel!
    
    weak var delegate: CSMoreStakesCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ value: Int) {
        subtitleLabel.text = "+\(value)"
    }
}

private extension CSMoreStakesCell {
    @objc func tapCell() { delegate?.tapMore() }
    
    func setup() {
        setupCell()
        setupMainView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupCell() {
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
        contentView.theme_backgroundColor = ThemeColorPicker(
            colors: "#2B2B2B", "#D8DBE5"
        )
    }
    
    func setupMainView() {
        let view = UIView()
        view.backgroundColor = .clear
        
        mainView = view
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.leading.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        label.font = R.font.lato_BBRegular(size: 10)
        label.text = "Ещё"
        
        titleLabel = label
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.height.equalTo(16)
        }
    }
    
    func setupSubtitleLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        label.font = R.font.lato_BBBold(size: 14)
        
        subtitleLabel = label
        mainView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.height.equalTo(16)
        }
    }
}
