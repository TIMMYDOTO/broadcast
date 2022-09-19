//
//  CSStakeCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SwiftTheme

protocol CSStakeCellDelegate: AnyObject {
    
    func tapStake(_ model: CSStake)
    
}

final class CSStakeCell: UICollectionViewCell {
    
    private weak var containerView: UIView!
    private weak var stakeView: UIView!
    
    private weak var stakeTypeLabel: UILabel!
    private weak var stakeFactorLabel: UILabel!
    private weak var bottomHighlightView: UIView!
    
    private weak var lockIcon: UIImageView!
    
    private var stakeTap: UITapGestureRecognizer!
    
    weak var delegate: CSStakeCellDelegate?
    
    var model: CSStake = CSStake()
    var stakeSelected: Bool = false { didSet{ updateSelectedState() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stakeTap.isEnabled = false
        stakeTap.isEnabled = true
        isUserInteractionEnabled = false
    }
    
    // MARK: - Public
    func configure(
        _ model: CSStake,
        selected: Bool,
        betStop: Bool
    ) {
        self.model = model
        stakeTypeLabel.text = model.shortName
        if model.active {
            stakeFactorLabel.text = formatFactor(model.factor)
            stakeFactorLabel.isHidden = false
            lockIcon.isHidden = true
        } else {
            stakeFactorLabel.text = ""
            stakeFactorLabel.isHidden = true
            lockIcon.isHidden = false
        }
        containerView.alpha = betStop ? 0.3 : 1
        stakeSelected = selected
        isUserInteractionEnabled = true
    }
    
    func highlight(_ model: StakeColor?) {
        bottomHighlightView.layer.removeAllAnimations()
        let color: UIColor
        switch model {
        case .green:
            color = Color.emeraldGreen
        case .red:
            color = Color.carmineRed
        case .none:
            clearHighlight()
            return
        }
        animateHighlight(color)
    }
    
    func placeholder(_ title: String) {
        self.model = CSStake()
        stakeTypeLabel.text = title
        stakeFactorLabel.text = "—"
        containerView.alpha = 0.3
        stakeSelected = false
    }
}

private extension CSStakeCell {
    // MARK: - Objcs
    @objc func tapCell() {
        delegate?.tapStake(model)
    }
    
    // MARK: - Setups
    func setup() {
        setupCell()
        setupStakeView()
        setupStakeTypeLabel()
        setupStakeFactorLabel()
        setupLockIcon()
        setupBottomHighlightView()
    }
    
    func setupCell() {
        clipsToBounds = true
        layer.cornerRadius = 8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        stakeTap = tap
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#2B2B2B", "#D8DBE5")
        containerView = view
        addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupStakeView() {
        let view = UIView()
        view.backgroundColor = .clear
        
        stakeView = view
        containerView.addSubview(stakeView)
        stakeView.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.leading.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupStakeTypeLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        label.font = R.font.lato_BBRegular(size: 10)
        
        stakeTypeLabel = label
        stakeView.addSubview(stakeTypeLabel)
        stakeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.height.equalTo(16)
        }
    }
    
    func setupStakeFactorLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        label.font = R.font.lato_BBBold(size: 14)
        
        stakeFactorLabel = label
        stakeView.addSubview(stakeFactorLabel)
        stakeFactorLabel.snp.makeConstraints {
            $0.top.equalTo(stakeTypeLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.height.equalTo(16)
        }
    }
    
    func setupLockIcon() {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = R.image.ic16Lock()
        icon.tintColor = UIColor(hex: "#737373")
        icon.isHidden = true
        
        lockIcon = icon
        stakeView.addSubview(lockIcon)
        lockIcon.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.center.equalTo(stakeFactorLabel.snp.center)
        }
    }
    
    func setupBottomHighlightView() {
        let view = UIView()
        view.backgroundColor = .clear
        
        bottomHighlightView = view
        containerView.addSubview(bottomHighlightView)
        bottomHighlightView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(3)
        }
    }
    
    // MARK: - Others
    func animateHighlight(_ color: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.bottomHighlightView.backgroundColor = color
        })
        UIView.animate(withDuration: 0.3, delay: 2.6, animations: {
            self.bottomHighlightView.backgroundColor = .clear
        })
    }
    
    func clearHighlight() {
        UIView.animate(withDuration: 0.3) {
            self.bottomHighlightView.backgroundColor = .clear
        }
    }
    
    func formatFactor(_ value: Double) -> String {
        let stringFactor = "\(value)"
        
        if stringFactor.hasSuffix(".0") {
            return stringFactor.dropLast(2).description
        } else { return stringFactor }
    }
    
    func updateSelectedState() {
        if stakeSelected {
            stakeTypeLabel.theme_textColor = ThemeColorPicker(
                colors: Color.deepBlack, Color.deepBlack
            )
            stakeFactorLabel.theme_textColor = ThemeColorPicker(
                colors: Color.deepBlack, Color.deepBlack
            )
            containerView.theme_backgroundColor = ThemeColorPicker(
                colors: Color.electricYellow, Color.electricYellow
            )
        } else {
            stakeTypeLabel.theme_textColor = ThemeColorPicker(
                colors: "#FFFFFF", "#0D0D0D"
            )
            stakeFactorLabel.theme_textColor = ThemeColorPicker(
                colors: "#FFFFFF", "#0D0D0D"
            )
            containerView.theme_backgroundColor = ThemeColorPicker(
                colors: "#2B2B2B", "#D8DBE5"
            )
        }
    }
}
