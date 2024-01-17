//
//  ResultAlreadyRegisteredViewController.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.09.2021.
//

import UIKit
import SwiftTheme
import Lottie

final class ResultAlreadyRegisteredViewController: UIViewController, SessionServiceDependency {
    
    var onShowPasswordRecovery: (() -> Void)?
    var onShowBets: (() -> Void)?
    var onAuth: (() -> Void)?
    private let globalInsets: UIEdgeInsets = {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return window?.safeAreaInsets ?? .zero
    }()
    
    private let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.09
        style.alignment = .center
        
        return style
    }()
    
    let titlesBottomOffset: CGFloat

    private weak var animationView: LottieAnimationView!
    private weak var titleLabel: UILabel!
    private weak var subtitleLabel: UILabel!
    
    private weak var passwordRecoveryButton: UIButton!
    private weak var betsButton: UIButton!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        let mainViewYOffset: CGFloat = -54 // смещение mainView от центра по Y для экранов высотой 812
        let mainViewHeight: CGFloat = 451 // в случае изменение высоты mainView нужно будет обновить это значение
        let globalHeightWithoutInsets = UIScreen.main.bounds.height - (globalInsets.top + globalInsets.bottom)
        titlesBottomOffset = mainViewYOffset * (UIScreen.main.bounds.height / 812) - (globalHeightWithoutInsets/2 - mainViewHeight/2)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        betsButton.enbaleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: !isMovingToParent)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private extension ResultAlreadyRegisteredViewController {
    func setup() {
        setupNavigationBar()
        setupView()
        setupBetsButton()
        setupPasswordRecoveryButton()
        setupSubtitleLabel()
        setupTitleLabel()
        setupAnimationView()
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    func setupView() {
        view.theme_backgroundColor = ThemeColor.backgroundPrimary
    }
    
    func setupBetsButton() {
        let button = UIButton()
        button.titleLabel?.font = R.font.lato_BBBold(size: 16)
        button.setTitle("Перейти к ставкам", for: .normal)
        
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapBetsButton), for: .touchUpInside)
        
        
        betsButton = button
        view.addSubview(betsButton)
        betsButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(globalInsets.bottom == 0 ? -16 : -24)
            $0.height.equalTo(56)
        }
    }
    
    func setupPasswordRecoveryButton() {
        let button = UIButton()
        button.titleLabel?.font = R.font.lato_BBBold(size: 16)
        button.setTitle("Восстановить пароль", for: .normal)
        button.theme_setTitleColor(ThemeColorPicker(colors: .white, Color.deepBlack), forState: .normal)
        button.theme_setTitleColor(ThemeColorPicker(colors: UIColor.white.withAlphaComponent(0.5), Color.deepBlack.withAlphaComponent(0.5)), forState: .highlighted)
        button.theme_backgroundColor = ThemeColorPicker(colors: "#0D0D0D", "#F6F7FB")
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.theme_borderColor = ThemeCGColorPicker(colors: "#737373", "#737373")
        button.addTarget(self, action: #selector(tapPasswordRecoveryButton), for: .touchUpInside)
        button.accessibilityIdentifier = "ResultAlreadyRegisteredScreen.RecoveryButton"
        
        passwordRecoveryButton = button
        view.addSubview(passwordRecoveryButton)
        passwordRecoveryButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(betsButton.snp.top).offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    func setupSubtitleLabel() {
        let label = UILabel()
        label.font = R.font.lato_BBRegular(size: 14)
        label.theme_textColor = ThemeColorPicker(colors: "#CCCCCC", "#737373")
        label.numberOfLines = 4
        
        label.attributedText = NSMutableAttributedString(
            string: "Если ты забыл пароль от своего счета,\nвоспользуйся сервисом восстановления\nпароля или обратись в службу поддержки\nклиентов.",
            attributes: [.paragraphStyle: paragraphStyle]
        )
        label.accessibilityIdentifier = "ResultAlreadyRegisteredScreen.SubtitleLabel"
        
        subtitleLabel = label
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(titlesBottomOffset)
            $0.height.equalTo(96)
        }
    }
    
    func setupTitleLabel() {
        let label = UILabel()
        label.font = R.font.robotoBold(size: 24)
        label.theme_textColor = ThemeColor.textPrimary
        label.numberOfLines = 2
        
        label.attributedText = NSMutableAttributedString(
            string: "Ты уже\nзарегистрирован",
            attributes: [.kern: 0.51, .paragraphStyle: paragraphStyle]
        )
        
        
        titleLabel = label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(subtitleLabel.snp.top)
            $0.height.equalTo(80)
        }
    }
    
    func setupAnimationView() {
        let animation = LottieAnimation.named("illustration_10")
        
        let placeholder = LottieAnimationView()
        placeholder.contentMode = .scaleAspectFit
        placeholder.animation = animation
        placeholder.loopMode = .loop
        placeholder.backgroundBehavior = .pauseAndRestore
        
        
        animationView = placeholder
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(291)
        }
        animationView.play()
    }
    
    @objc func tapPasswordRecoveryButton() {
        
        
//        session.removeToken()
//        userService.clearUserState()
        
//        onShowPasswordRecovery?()
    }
    
    @objc func tapBetsButton() {
        session.hasToken ? goToMain() : goToAuth()

    }
    
    func goToMain() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToAuth() {
        
    }
}
