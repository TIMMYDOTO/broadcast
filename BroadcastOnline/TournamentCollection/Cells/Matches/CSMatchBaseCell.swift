//
//  CSMatchBaseCell.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SwiftTheme

protocol CSMatchCellDelegate: AnyObject {
    
    func willSelectMatch(_ match: CSMatch)
    
    func switchFavorite(_ match: CSMatch)
    
    func stakeSelected(match: CSMatch, stake: CSStake)
    
    func stakeUnselected(match: CSMatch, stake: CSStake)
    
    func saveStakesOffset(matchId: String, x: CGFloat)
    
    
    func setCurrentDeleting(_ id: String)
    
    func setDeletingIsAvailable()
    
    func checkDeletingIsAvailable(_ id: String) -> Bool
    
}

class CSMatchBaseCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let favoriteColor = ThemeColorPicker(
        colors: "#F8E800", "#FFBA33"
    )
    private let unfavoriteColor = ThemeColorPicker(
        colors: "#CCCCCC", "#CCCCCC"
    )
    
    private weak var favoriteView: UIView!
    private weak var favoriteIcon: UIImageView!
    
    weak var mainView: UIView!
    
    weak var stakesCollection: CSStakesCollection!
    weak var infoView: UIView!
    
    private var favoritePan: UIPanGestureRecognizer!
    
    var model: CSMatch = CSMatch()
    
    var favorite: Bool = false
    private var favoriteIsChanging: Bool = false
    
    weak var delegate: CSMatchCellDelegate?
    
    // MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stakesCollection.clear()
    }
    
    // MARK: - Public
    func configure(_ model: CSMatch, stakesOffset: CGFloat) {
        self.model = model
        let height: CGFloat = 72
        
        stakesCollection.set(
            model.stakes,
            total: model.stakesCount,
            betStop: model.betStop,
            cellHeight: height,
            stakesOffset: stakesOffset
        )
    }
    
    func highlight(_ old: CSMatch) {
        if model.id != old.id { return }
        
        stakesCollection.highlight(old.stakes)
    }
    
    func favoriteState(_ active: Bool) {
        favorite = active
        favoriteIcon.theme_tintColor = active ? favoriteColor : unfavoriteColor
    }
}

extension CSMatchBaseCell: LongTapDelegate {
    func betFailed() {
//        delegate?.longTapBetFailed()
    }
    
    func makeBet(_ bet: Bet) {} ///UNUSED
}

extension CSMatchBaseCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: contentView)

            if pan == favoritePan {
                return abs(velocity.y) < abs(velocity.x);
            } else {
                return abs(velocity.y) > abs(velocity.x);
            }
        }
        return true
    }
}

// MARK: - Private
private extension CSMatchBaseCell {
    // MARK: - Objcs
    @objc func tapInfoView() {
        delegate?.willSelectMatch(model)
    }
    
    @objc func panInfoView(_ recognizer: UIPanGestureRecognizer) {
        guard
            let _ = recognizer.view,
            let delegate = delegate,
            delegate.checkDeletingIsAvailable(model.id)
        else {
            recognizer.isEnabled = false
            recognizer.isEnabled = true
            return
        }
        
        let xTranslation = recognizer.translation(in: contentView).x
        let result = (1 / (xTranslation/400 + 1)) * xTranslation
        
        switch recognizer.state {
        case .began:
            delegate.setCurrentDeleting(model.id)
        case .changed:
            mainView.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(max(result, 0))
            }
            contentView.layoutIfNeeded()
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
                self.contentView.layoutIfNeeded()
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
                        self.contentView.layoutIfNeeded()
                    } completion: { finished in
                        self.favoriteIsChanginAction(false, notificated: false)
                        delegate.setDeletingIsAvailable()
                    }
                    delegate.switchFavorite(self.model)
                } else {
                    delegate.setDeletingIsAvailable()
                }
            }
        default:
            break
        }
    }
    
    @objc func longPressStakes(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if model.betStop { return }
            
            let point = gestureRecognizer.location(in: stakesCollection)

            if
                let indexPath = stakesCollection.indexPathForItem(at: point),
                let stake = (stakesCollection.cellForItem(at: indexPath) as? CSStakeCell)?.model,
                !stake.id.isEmpty,
                stake.active
            {
                var bet = Bet()
                bet.csMatch = model
                bet.csStake = stake
                bet.isCS = true
                
                let position = indexPath.item
                QuickBetLandscape.shared.makeBet(bet, screenOrientation: .portrait, fromScreen: .cybersport, position: position)
            }
            return
        }
        if gestureRecognizer.state == .ended {
            QuickBetLandscape.shared.cancelAction()
            return
        }
    }
    
    // MARK: - Bingings
    func bindings() {
        bindStakesCollection()
    }
    
    func bindStakesCollection() {
        stakesCollection.didScroll = { [weak self] x in
            guard let self = self else { return }
            
            self.delegate?.saveStakesOffset(
                matchId: self.model.id,
                x: x
            )
        }
        
        stakesCollection.willSelectStake = { [weak self] stake in
            guard let self = self else { return }
            
            self.delegate?.stakeSelected(match: self.model, stake: stake)
        }
        
        stakesCollection.willUnselectStake = { [weak self] stake in
            guard let self = self else { return }
            
            self.delegate?.stakeUnselected(match: self.model, stake: stake)
        }
        
        stakesCollection.willSelectMore = { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.willSelectMatch(self.model)
        }
    }
    // MARK: - Setups
    func setup() {
        setupCell()
        setupMainView()
        setupFavoriteView()
        setupStakesCollection()
        setupInfoContainer()
    }
    
    func setupCell() {
        let bottomView = UIView()
        bottomView.theme_backgroundColor = ThemeColorPicker(colors: "#0D0D0D", "#FFFFFF")
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.bottom.trailing.leading.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    func setupMainView() {
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#181818", "#F6F7FB")
        
        mainView = view
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    func setupFavoriteView() {
        let view = UIView()
        view.theme_backgroundColor = ThemeColorPicker(colors: "#29292B", "#EDEEF2")
        
        let icon = UIImageView(image: R.image.ic24Favorite())
        icon.theme_tintColor = ThemeColorPicker(colors: "#CCCCCC", "#CCCCCC")
        
        favoriteIcon = icon
        view.addSubview(favoriteIcon)
        favoriteIcon.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        favoriteView = view
        contentView.addSubview(favoriteView)
        favoriteView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(-3)
            $0.bottom.equalToSuperview().offset(-2)
            $0.trailing.equalTo(mainView.snp.leading).offset(-2)
        }
    }
    
    func setupStakesCollection() {
        let collection = CSStakesCollection()
        collection.backgroundColor = .clear
        
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressStakes(gestureRecognizer:))
        )
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        
        collection.addGestureRecognizer(longPress)
        collection.isUserInteractionEnabled = true
        
        stakesCollection = collection
        mainView.addSubview(stakesCollection)
        stakesCollection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(210)
        }
        stakesCollection.allowDelegates()
    }
    
    func setupInfoContainer() {
        let view = UIView()
        view.backgroundColor = .clear

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapInfoView))
        view.addGestureRecognizer(tap)
        /*
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panInfoView))
        pan.delegate = self
        favoritePan = pan
        view.addGestureRecognizer(pan)
        */
        
        view.isUserInteractionEnabled = true
        
        infoView = view
        mainView.addSubview(infoView)
        infoView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(stakesCollection.snp.leading)
        }
    }
    
    // MARK: - Othrers
    func favoriteIsChanginAction(_ changing: Bool, notificated: Bool) {
        if favoriteIsChanging == changing { return }
        favoriteIsChanging = changing
        
        let defaultColor = favorite ? favoriteColor : unfavoriteColor
        let changedColor = favorite ? unfavoriteColor : favoriteColor
        
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
