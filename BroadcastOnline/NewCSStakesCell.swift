//
//  NewCSStakesCollection.swift
//  BroadcastOnline
//
//  Created by Artyom on 16.09.2022.
//

import UIKit

class NewCSStakesCell: UICollectionViewCell {
    
    private var stakeTap: UITapGestureRecognizer!
    var model: CSStake = CSStake()
    private weak var stakeTypeLabel: UILabel!{
        didSet{
            stakeTypeLabel.font = R.font.robotoRegular(size: 12)
        }
    }
    private weak var stakeFactorLabel: UILabel!{
        didSet{
            stakeFactorLabel.font = R.font.robotoBold(size: 12)
        }
    }
    private weak var lockIcon: UIImageView!
    private weak var iconImageView: UIImageView!
    weak var delegate: CSStakeCellDelegate?
    private weak var bottomHighlightView: UIView!
    
    
    func configure(_ model: CSStake) {
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
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
    
        setupCell()
        setupStakeTypeLabel()
        setupStakeFactorLabel()
        setupIconImageView()
        setupLockIcon()
    }
    func setupCell() {
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.2913191915, green: 0.3439336419, blue: 0.4444465041, alpha: 1)
        layer.cornerRadius = 8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        stakeTap = tap
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
      
    }
    
    @objc func tapCell() {
        delegate?.tapStake(model)
    }
    
    func setupLockIcon() {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = R.image.ic16Lock()
        icon.tintColor = UIColor(hex: "#737373")
        icon.isHidden = true
        
        lockIcon = icon

        addSubview(lockIcon)
        lockIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.height.equalTo(16)
            $0.centerY.equalTo(stakeFactorLabel.snp.centerY)
        }
    }
    
    func setupIconImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "green")
        iconImageView = imageView
        iconImageView.isHidden = true
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(stakeFactorLabel.snp.leading).offset(-4)
            make.width.equalTo(11)
            make.height.equalTo(5)
        }
    }
    
    func setupStakeTypeLabel() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 0.6601216793, green: 0.6862185597, blue: 0.7269647121, alpha: 1)
        label.font = R.font.robotoRegular(size: 12)
        stakeTypeLabel = label
        addSubview(stakeTypeLabel)
        stakeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
        
            $0.height.equalTo(16)
        }
    }
    
    func setupStakeFactorLabel() {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .white
        label.font = R.font.lato_BBBold(size: 14)
        
        stakeFactorLabel = label
        addSubview(stakeFactorLabel)
        stakeFactorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(16)
        }
    }
    
    func highlight(_ model: StakeColor?) {
        stakeFactorLabel.layer.removeAllAnimations()
        let color: UIColor
        switch model {
        case .green:
            color = Color.emeraldGreen
            showIconImageViewGreen()
        case .red:
            color = Color.carmineRed
            showIconImageViewRed()
        case .none:
            
            clearHighlight()
            return
        }
        animateHighlight(color)
    }
    
    func showIconImageViewRed() {
        
        UIView.animate(withDuration: 0.3) {

            self.iconImageView.isHidden = false
            self.iconImageView.tintColor = Color.carmineRed
        } completion: { _ in
            
        }
        
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            self.iconImageView.isHidden = true
        }


    }
    

    
    func animateHighlight(_ color: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
        
            self.stakeFactorLabel.textColor = color
        })
        
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            self.stakeFactorLabel.textColor = .white
        }
        


    }
    
    func showIconImageViewGreen() {
        self.iconImageView.transform = .init(rotationAngle: CGFloat(Double.pi))
        UIView.animate(withDuration: 0.3) {
            
            self.iconImageView.isHidden = false
            self.iconImageView.tintColor = Color.emeraldGreen
        } completion: { _ in
            
        }
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            self.iconImageView.isHidden = true
        }
        
     
    }
        
        
    
    
    func clearHighlight() {
        UIView.animate(withDuration: 0.3) {
            self.stakeFactorLabel.textColor = .white
            self.iconImageView.tintColor = .clear
        }
    }
    
    func formatFactor(_ value: Double) -> String {
        let stringFactor = "\(value)"
        
        if stringFactor.hasSuffix(".0") {
            return stringFactor.dropLast(2).description
        } else { return stringFactor }
    }
    
}


