//
//  CyberSportGameCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.03.2022.
//

import UIKit


class CyberSportGameCell: UICollectionViewCell {
    
    private let iconContainerColor = UIColor.clear
    
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
//        bottomRadialGradient.frame = CGRect(x: (contentView.frame.width / 2) - 60, y: contentView.frame.height - 50, width: 120, height: 50)
//        sportIconContainerInnerShadow.frame = CGRect(x: -8, y: -16, width: 56, height: 56)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        setState(false, theme: .clear)
        sportIconView.clear()
    }
    
    func configure(_ model: CSSportInfo, selected: Bool) {
        titleLabel.textColor = getTitleLabelStateColor(active: selected)
        titleLabel.text = model.abbreviation
//        liveLabelContainer.isHidden = !model.hasLive
        
        let type = CSTypeProvider.getInfoVM(id: model.id)
        setState(selected, theme: type.color)
        
        sportIconView.set(model, vm: type)
        
//        sportIconContainerBorder.isHidden = false
//        bottomRadialGradient.isHidden = false
//        sportIconContainerInnerShadow.isHidden = false
        sportIconView.clipsToBounds = true
      
        
    }
    
//    func testHide() {
//        setState(false, theme: .clear)
//    }
    
    func setState(_ selected: Bool, theme: UIColor) {
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 0.5)
        layer.cornerRadius = 8
        
//        let duration = 0.2
//
        if selected {
            layer.borderWidth = 0
            backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.2235294118, blue: 0.3098039216, alpha: 1)
            titleLabel.textColor = .white
            sportIconView.active()
        }else{
            layer.borderWidth = 2
            backgroundColor = .clear
            titleLabel.textColor = #colorLiteral(red: 0.5960784314, green: 0.6235294118, blue: 0.6705882353, alpha: 1)
            sportIconView.inactive()
        }
    

    }
}

private extension CyberSportGameCell {
    func setup() {
        setupSportIconContainer()
        setupTitleLabel()
//        setupLiveLabelContainer()
//        setupLiveLabel()
//        setupSportIconContainerBorder()
//        setupSportIconContainerInnerGradient()
        setupBottomRadialGradient()
    }
    
    func setupSportIconContainer() {
        let container = CyberSportIconView()
        container.backgroundColor = iconContainerColor
//        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        
//        container.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
//        container.layer.shadowOpacity = 1
//        container.layer.shadowRadius = 16
//        container.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        sportIconView = container
        contentView.addSubview(sportIconView)
        sportIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.height.width.equalTo(34)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.robotoMedium(size: 12)
        
        label.textColor = getTitleLabelStateColor(active: false)
        
        titleLabel = label
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(sportIconView.snp.bottom).offset(9)
            $0.bottom.equalToSuperview().offset(-8)
            $0.trailing.equalToSuperview().offset(-3)
            $0.leading.equalToSuperview().offset(3)
            $0.height.equalTo(16)
            $0.width.greaterThanOrEqualTo(44)
        }
    }
    
    func setupLiveLabelContainer() {
        let view = UIView()
        
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
        label.font = UIFont.systemFont(ofSize: 8)
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
    
    func getTitleLabelStateColor(active: Bool) -> UIColor {
        return active ? .lightGray : .midnightBlue
    }
}
