//
//  CyberSportGameCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.03.2022.
//

import UIKit
import SwiftTheme

class CyberSportGameCell: UICollectionViewCell {
    
    private let iconContainerColor = ThemeColorPicker(colors: "#1F1F1F", "#FFFFFF")
    
    private weak var sportIconView: CyberSportIconView!
//    private weak var sportIcon: CyberSportIconImageView!
    private weak var titleLabel: UILabel!
    
    private weak var liveLabelContainer: UIView!
    private weak var liveLabel: UILabel!
    
    private var sportIconContainerBorder: CAGradientLayer!
    private var sportIconContainerInnerShadow: CAGradientLayer!
    private var bottomRadialGradient: CAGradientLayer!
    
    private var activeIcon: UIImage = UIImage()
    private var unactiveIcon: UIImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomRadialGradient.frame = CGRect(x: (contentView.frame.width / 2) - 60, y: contentView.frame.height - 50, width: 120, height: 50)
        sportIconContainerInnerShadow.frame = CGRect(x: -8, y: -16, width: 56, height: 56)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setState(false, theme: .clear)
        sportIconView.clear()
    }
    
    func configure(_ model: CSSportInfo, selected: Bool) {
        titleLabel.theme_textColor = getTitleLabelStateColor(active: selected)
        titleLabel.text = model.abbreviation
        liveLabelContainer.isHidden = !model.hasLive
        
        let type = CSTypeProvider.getInfoVM(id: model.id)
        setState(selected, theme: type.color)
        
        sportIconView.set(model, vm: type)
        
        sportIconContainerBorder.isHidden = false
        if BBTheme.isNight() {
            bottomRadialGradient.isHidden = false
            sportIconContainerInnerShadow.isHidden = false
            sportIconView.clipsToBounds = true
        } else {
            bottomRadialGradient.isHidden = true
            sportIconContainerInnerShadow.isHidden = true
            sportIconView.clipsToBounds = false
        }
        
    }
    
//    func testHide() {
//        setState(false, theme: .clear)
//    }
    
    func setState(_ selected: Bool, theme: UIColor) {
        let duration = 0.2
        
        selected ? sportIconView.active() : sportIconView.inactive()
        
        let first = CABasicAnimation(keyPath: "colors")
        first.isRemovedOnCompletion = false
        first.duration = duration
        first.fillMode = CAMediaTimingFillMode.forwards
        first.toValue = selected ? [
            theme.withAlphaComponent(0).cgColor,
            theme.cgColor
        ] : [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor
        ]
        sportIconContainerBorder.add(first, forKey: nil)
        
        let second = CABasicAnimation(keyPath: "colors")
        second.isRemovedOnCompletion = false
        second.duration = duration
        second.fillMode = CAMediaTimingFillMode.forwards
        second.toValue = selected ? [
            theme.withAlphaComponent(0.5).cgColor,
            theme.withAlphaComponent(0).cgColor
        ] : [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor
        ]
        bottomRadialGradient.add(second, forKey: nil)
        
        let third = CABasicAnimation(keyPath: "colors")
        third.isRemovedOnCompletion = false
        third.duration = duration
        third.fillMode = CAMediaTimingFillMode.forwards
        third.toValue = selected ? [
            theme.withAlphaComponent(0).cgColor,
            theme.withAlphaComponent(0).cgColor,
            theme.withAlphaComponent(0.3).cgColor
        ] : [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor
        ]
        sportIconContainerInnerShadow.add(third, forKey: nil)
    }
}

private extension CyberSportGameCell {
    func setup() {
        setupSportIconContainer()
        setupTitleLabel()
        setupLiveLabelContainer()
        setupLiveLabel()
        setupSportIconContainerBorder()
        setupSportIconContainerInnerGradient()
        setupBottomRadialGradient()
    }
    
    func setupSportIconContainer() {
        let container = CyberSportIconView()
        container.theme_backgroundColor = iconContainerColor
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        
        container.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowRadius = 16
        container.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        sportIconView = container
        contentView.addSubview(sportIconView)
        sportIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.height.width.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.lato_BBBold(size: 12)
        label.theme_textColor = getTitleLabelStateColor(active: false)
        
        titleLabel = label
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sportIconView.snp.bottom).offset(9)
            $0.trailing.equalToSuperview().offset(-3)
            $0.leading.equalToSuperview().offset(3)
            $0.height.equalTo(14)
            $0.width.greaterThanOrEqualTo(44)
        }
    }
    
    func setupLiveLabelContainer() {
        let view = UIView()
        view.backgroundColor = Color.carmineRed
        view.layer.cornerRadius = 2
        view.isHidden = true
        
        liveLabelContainer = view
        contentView.addSubview(liveLabelContainer)
        liveLabelContainer.snp.makeConstraints {
            $0.bottom.equalTo(sportIconView.snp.top).offset(6)
            $0.leading.equalTo(sportIconView.snp.trailing).offset(-11)
            $0.width.equalTo(19)
            $0.height.equalTo(10)
        }
    }
    
    func setupLiveLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.lato_BBBold(size: 8)
        label.textAlignment = .center
        label.text = "Live"
        
        liveLabel = label
        liveLabelContainer.addSubview(liveLabel)
        liveLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.leading.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.height.equalTo(6)
        }
    }
    
    func setupSportIconContainerBorder() {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(
            roundedRect: CGRect(x: 0.5, y: 0.5, width: 39, height: 39),
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
        shape.strokeColor = UIColor.clear.withAlphaComponent(0.5).cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        sportIconContainerBorder = gradient
        sportIconView.layer.addSublayer(sportIconContainerBorder)
    }
    
    func setupSportIconContainerInnerGradient() {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.5, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        sportIconContainerInnerShadow = gradient
        sportIconView.layer.addSublayer(sportIconContainerInnerShadow)
    }
    
    func setupBottomRadialGradient() {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        
        bottomRadialGradient = gradient
        contentView.layer.addSublayer(bottomRadialGradient)
    }
    
    func getTitleLabelStateColor(active: Bool) -> ThemeColorPicker {
        return active ? ThemeColor.textPrimary : ThemeColorPicker(colors: "#CCCCCC", "#A1A3AB")
    }
}
