//
//  CSTournamentHeader.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SwiftTheme

protocol CSTournamentHeaderDelegate: AnyObject {
    
    func tapTournamentHeader(_ id: String)
    
    func switchFavorite(_ tournamentId: String)
    
    
    func setCurrentDeleting(_ id: String)
    
    func setDeletingIsAvailable()
    
    func checkDeletingIsAvailable(_ id: String) -> Bool
    
}

class CSTournamentHeader: UICollectionReusableView {
    
    private weak var favoriteView: UIView!
    private weak var favoriteIcon: UIImageView!
    
    private weak var mainView: UIView!
    
    private weak var sportColorIndicator: UIView!
    private weak var titleLabel: UILabel!
    
    private weak var countView: UIView!
        private weak var countLabel: UILabel!
        private weak var arrowIcon: UIImageView!
    private weak var collapseButton: UIButton!
    
    private var favoritePan: UIPanGestureRecognizer!
    
    weak var delegate: CSTournamentHeaderDelegate?
    
    var tournamentId: String?
    var favorite: Bool = false
    
    var favoriteIsChanging = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        mainView.snp.updateConstraints {
//            $0.leading.equalToSuperview().offset(16)
//            $0.trailing.equalToSuperview().offset(-16)
//            $0.leading.equalToSuperview()
//
//        }
    }
    
    func configure(_ model: CSTournamentInfo, collapsed: Bool) {
        tournamentId = model.id
        
        titleLabel.text = model.name

        sportColorIndicator.backgroundColor = CSTypeProvider.getInfoVM(id: model.sportId).color
//        countLabel.text = "\(model.matchesCount)"
        arrowIcon.transform = collapsed ? .init(rotationAngle: CGFloat(Double.pi)) : .identity
        configureState(collapse: collapsed)
    }
    
    func configure(_ model: CSTournamentInfo, collapsed: Bool, count: Int) {
        tournamentId = model.id
        
        sportColorIndicator.backgroundColor = CSTypeProvider.getInfoVM(id: model.sportId).color
//        countLabel.text = "\(count)"
        arrowIcon.transform = collapsed ? .init(rotationAngle: CGFloat(Double.pi)) : .identity
        configureState(collapse: collapsed)
    }
    
  
}

private extension CSTournamentHeader {
    func setup() {
        setupMainView()
        setupCollapseButton()
        setupSportColorIndicator()
//        setupFavoriteView()
        setupArrowIcon()
        setupTitleLabel()
//        setupCountView()
//        setupCountLabel()
      
   
  
    }
    
    func setupMainView() {
        let view = UIView()
        view.isUserInteractionEnabled = true
        /*
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pagGestureFieldView(_:)))
        pan.delegate = self
        favoritePan = pan
        view.addGestureRecognizer(pan)
        */
        mainView = view
        mainView.backgroundColor = #colorLiteral(red: 0.06419743598, green: 0.08443901688, blue: 0.1187562123, alpha: 1)
        addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        
    }
    
    func setupSportColorIndicator() {
        let view = UIView()
        view.isHidden = true
        
        sportColorIndicator = view
        mainView.addSubview(sportColorIndicator)
        sportColorIndicator.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(2)
        }
    }
    
    
    func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.robotoBold(size: 12)
        
        
        titleLabel = label
        collapseButton.addSubview(titleLabel)
        titleLabel.snp.contentHuggingHorizontalPriority = 249
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(arrowIcon.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
    
    func setupCountView() {
        let view = UIView()
        view.layer.cornerRadius = 4
        
        countView = view
        mainView.addSubview(countView)
        countView.snp.makeConstraints {
//            $0.leading.equalTo(titleLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(12)
            $0.width.greaterThanOrEqualTo(16)
        }
    }
    
    func setupCountLabel() {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10)
        
        label.textAlignment = .center
        
        countLabel = label
        countView.addSubview(countLabel)
        countLabel.snp.contentHuggingHorizontalPriority = 250
        countLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func setupArrowIcon() {
        let icon = UIImageView(image: UIImage(named: "ic10ArrowDown"))
        icon.tintColor = .white
        
        arrowIcon = icon
        mainView.addSubview(arrowIcon)
//        arrowIcon.snp.contentHuggingHorizontalPriority = 251
        arrowIcon.snp.makeConstraints {
            
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(12)
            $0.width.equalTo(16)
        }
    }
    
    func setupCollapseButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        
        collapseButton = button
        collapseButton.layer.cornerRadius = 16
//        collapseButton.backgroundColor = #colorLiteral(red: 0.6601216793, green: 0.6862185597, blue: 0.7269647121, alpha: 1)

        mainView.addSubview(collapseButton)
        collapseButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func tap() {
        guard let id = tournamentId else { return }
        
        delegate?.tapTournamentHeader(id)
    }
    
    @objc func pagGestureFieldView(_ recognizer: UIPanGestureRecognizer) {
        guard
            let _ = recognizer.view,
            let id = self.tournamentId,
            let delegate = delegate,
            delegate.checkDeletingIsAvailable(id)
        else {
            recognizer.isEnabled = false
            recognizer.isEnabled = true
            return
        }
        
        let xTranslation = recognizer.translation(in: self).x
        let result = (1 / (xTranslation/400 + 1)) * xTranslation
        
        switch recognizer.state {
        case .began:
            delegate.setCurrentDeleting(id)
        case .changed:
            mainView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(max(result, 0))
            }
            layoutIfNeeded()
            self.favoriteIsChanginAction(result > 120, notificated: true)
        case .ended:
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                options: .curveEaseIn
            ) {
                let leftInset = self.favoriteIsChanging ? 50 : 0
                self.mainView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(leftInset)
                }
                self.layoutIfNeeded()
            } completion: { _ in
                if self.favoriteIsChanging {
                    UIView.animate(
                        withDuration: 0.4,
                        delay: 0.1,
                        usingSpringWithDamping: 1.0,
                        initialSpringVelocity: 0.0,
                        options: .curveEaseIn
                    ) {
                        self.mainView.snp.updateConstraints {
                            $0.leading.equalToSuperview()
                        }
                        self.layoutIfNeeded()
                    } completion: { finished in
                        self.favoriteIsChanginAction(false, notificated: false)
                    }
                    delegate.switchFavorite(id)
                } else {
                    delegate.setDeletingIsAvailable()
                }
            }
        default:
            break
        }
    }
    
    func configureState(collapse: Bool) {
        if collapse {
            collapseButton.backgroundColor = #colorLiteral(red: 0.2406542599, green: 0.2908609807, blue: 0.3834058642, alpha: 1)
//            mainView.theme_backgroundColor = ThemeColorPicker(colors: "#333333", "#EDEEF2")
//            countView.theme_backgroundColor = ThemeColorPicker(colors: "#FFFFFF", "#FFFFFF")
//            countLabel.theme_textColor = ThemeColorPicker(colors: "#0D0D0D", "#0D0D0D")
            arrowIcon.theme_tintColor = ThemeColorPicker(colors: "#0D0D0D", "#0D0D0D")
        } else {
            collapseButton.backgroundColor = #colorLiteral(red: 0.1236208603, green: 0.153539598, blue: 0.2130726874, alpha: 1)
      
//            mainView.theme_backgroundColor = ThemeColorPicker(colors: "#212121", "#EDEEF2")
//            countView.theme_backgroundColor = ThemeColorPicker(colors: "#333333", "#D2D5E0")
//            countLabel.theme_textColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
            arrowIcon.theme_tintColor = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
        }
    }
    
    func favoriteIsChanginAction(_ changing: Bool, notificated: Bool) {
        if favoriteIsChanging == changing { return }
        favoriteIsChanging = changing
        
        let defaultColor = favorite ? ThemeColorPicker(colors: "#F8E800", "#FFBA33") : ThemeColorPicker(colors: "#CCCCCC", "#CCCCCC")
        let changedColor = favorite ? ThemeColorPicker(colors: "#CCCCCC", "#CCCCCC") : ThemeColorPicker(colors: "#F8E800", "#FFBA33")
        
        favoriteIcon.theme_tintColor = changing ? changedColor : defaultColor
        
        if notificated {
            UIImpactFeedbackGenerator().impactOccurred()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.favoriteIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.favoriteIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }, completion: nil)
        }
    }
}

extension CSTournamentHeader: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: self)

            if pan == favoritePan {
                return abs(velocity.y) < abs(velocity.x);
            } else {
                return abs(velocity.y) > abs(velocity.x);
            }
        }
        return true
    }
}
