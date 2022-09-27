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
    
    private var animationView = UIImageView()
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
//        animationView.play()
    }
    
 
}

private extension NoConnectionViewController {
    func setup() {
        setupView()
        
             setupAnimationView()
        setupTitleLabel()
        setupSubtitleLabel()
   
    }
    
    func setupView() {
        view.theme_backgroundColor = ThemeColor.backgroundPrimary
    }
    
    func setupSubtitleLabel() {
        let label = UILabel()
        label.font = R.font.lato_BBRegular(size: 16)
        label.textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.5)
        label.numberOfLines = 2
        
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(48)
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.font = R.font.robotoBold(size: 32)
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
            $0.top.equalTo(animationView.snp.bottom).offset(25)
            $0.height.equalTo(40)
        }
    }
    
    func setupAnimationView() {
        animationView.image = UIImage(named: "palm")

//        animationView.contentMode = .scaleAspectFit
//        animationView.animation = animation
//        animationView.loopMode = .loop
        
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
    }
    
    @objc func didBecomeActive() {
//            animationView.play()
        }
}
