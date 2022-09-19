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
    
    weak var delegate: CSStakeCellDelegate?
    
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
    @objc func tapCell() {
        delegate?.tapStake(CSStake())
        
    }
    
    func setup() {
        setupCell()
//        setupMainView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupCell() {
        clipsToBounds = true
        
        backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.2913191915, green: 0.3439336419, blue: 0.4444465041, alpha: 1)
        layer.cornerRadius = 8

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
        label.textColor = #colorLiteral(red: 0.6601216793, green: 0.6862185597, blue: 0.7269647121, alpha: 1)
        label.font = R.font.robotoRegular(size: 12)
        label.text = "Ещё"
        
        titleLabel = label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
            
            $0.height.equalTo(16)
        }
    }
    
    func setupSubtitleLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        label.font = R.font.robotoBold(size: 12)
        
        subtitleLabel = label
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
        
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(16)
        }
    }
}
