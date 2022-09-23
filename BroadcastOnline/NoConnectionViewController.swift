//
//  NoConnectionViewController.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.10.2021.
//

import UIKit
import Lottie


class NoConnectionViewController: UIViewController {

    private let globalInsets: UIEdgeInsets = {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return window?.safeAreaInsets ?? .zero
    }()
    
    let mainBottomOffset: CGFloat
    
    private var animationView = AnimationView()
    private weak var titleLabel: UILabel!
    private weak var subtitleLabel: UILabel!
    
    init() {
        let mainViewYOffset: CGFloat = -71 // смещение mainView от центра по Y для экранов высотой 812
        let mainViewHeight: CGFloat = 392 // в случае изменение высоты mainView нужно будет обновить это значение
        let globalHeightWithoutInsets = UIScreen.main.bounds.height - (globalInsets.top + globalInsets.bottom)
        mainBottomOffset = mainViewYOffset * (UIScreen.main.bounds.height / 812) - (globalHeightWithoutInsets/2 - mainViewHeight/2)
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
 
}

private extension NoConnectionViewController {
    func setup() {
        setupView()
        setupSubtitleLabel()
        setupTitleLabel()
        setupAnimationView()
    }
    
    func setupView() {
        view.theme_backgroundColor = ThemeColor.backgroundPrimary
    }
    
    func setupSubtitleLabel() {
        let label = UILabel()
        label.font = R.font.lato_BBRegular(size: 14)
        label.textColor = .white
        label.numberOfLines = 3
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.25
        style.alignment = .center
        let makeSureConnection = NSLocalizedString("MakeSureConnection", comment: "NoMatches Title")
        label.attributedText = NSMutableAttributedString(
            string: makeSureConnection,
            attributes: [.kern: 0.26, .paragraphStyle: style]
        )
        
        subtitleLabel = label
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(mainBottomOffset)
            $0.height.equalTo(72)
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.font = R.font.gilroyBold(size: 24)
        label.theme_textColor = ThemeColor.textPrimary
        label.numberOfLines = 1
        let noConnection = NSLocalizedString("NoConnection", comment: "NoMatches Title")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.03
        style.alignment = .center
        label.attributedText = NSMutableAttributedString(
            string: noConnection,
            attributes: [.kern: 0.51, .paragraphStyle: style]
        )
        
        titleLabel = label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-8)
            $0.height.equalTo(32)
        }
    }
    
    func setupAnimationView() {
        let animation = Animation.named("illustration_6")
        
//        let placeholder = AnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.animation = animation
        animationView.loopMode = .loop
        
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(256)
            $0.height.equalTo(256)
        }
    }
    
    @objc func didBecomeActive() {
            animationView.play()
        }
}
