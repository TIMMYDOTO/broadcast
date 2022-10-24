//
//  BroadcastViewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 14.09.2022.
//

import UIKit

class BroadcastViewController: UIViewController {
    
    var closeButton: UIButton!
    var fullscreenButton: UIButton!
    var volumeButton: UIButton!
    private weak var translationView: CSDetailsHeaderTranslationView!
    var hasClickedDismiss = false
    var match: CSMatch!
    var viewTranslation = CGPoint(x: 0, y: 0)
    let height = UIScreen.main.bounds.width * 0.5625
    private weak var contentView: UIView!
    private weak var zalupkaView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        
        setupTranslationView()
        translationView.configure(match.stream)
        setupCloseButton()
//        setupVolumeButton()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickDismiss)))
        setupFullscreenButton()
        addZalupkaView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.all)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
   }
    
    private func addZalupkaView() {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        zalupkaView = view
        contentView.addSubview(zalupkaView)
        zalupkaView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(31)
            make.height.equalTo(3)
            make.top.equalToSuperview().offset(8)
        }
    }
    
    private func setupContentView() {
        let view = UIView()
        
        view.backgroundColor = .clear
        contentView = view
        self.view.addSubview(contentView)
        contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            make.height.equalTo(height + 30)
        }
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        if !UIDevice.current.orientation.isLandscape {
            switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                if viewTranslation.y > 0 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                }
                
                
            case .ended:
                if viewTranslation.y < 200 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.contentView.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
        }
        
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupFullscreenButton() {
        let image = UIImage(named: "fullscreen")
        let button = UIButton()
        button.setImage(image, for: .normal)
        fullscreenButton = button
        translationView.addSubview(fullscreenButton)
        fullscreenButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        button.addTarget(self, action: #selector(didClickFullScreen), for: .touchUpInside)
    }
    
    private func setupVolumeButton() {
        let image = UIImage(named: "unmute")
        let button = UIButton()
        button.setImage(image, for: .normal)
        volumeButton = button
        translationView.addSubview(volumeButton)
        volumeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        button.addTarget(self, action: #selector(didClickVolume), for: .touchUpInside)
    }
    
    private func setupCloseButton() {
        let image = UIImage(named: "CloseIcon")
        let button = UIButton()
        button.setImage(image, for: .normal)
        closeButton = button
        view.addSubview(closeButton)
        closeButton.isHidden = true
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        button.addTarget(self, action: #selector(didClickDismiss), for: .touchUpInside)
    }
    
    func setupTranslationView() {
        let translationview = CSDetailsHeaderTranslationView()
        
        
        translationView = translationview
        
        contentView.addSubview(translationView)
        
        translationView.snp.makeConstraints {
            
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           if UIDevice.current.orientation.isLandscape {
               closeButton.isHidden = false
               zalupkaView.isHidden = true
               translationView.webView.scrollView.contentSize = size
               
               contentView.snp.remakeConstraints { make in
                   make.leading.equalToSuperview()
                   make.trailing.equalToSuperview()
                   make.top.equalToSuperview()
                   make.bottom.equalToSuperview()
               }
               
               
               translationView.snp.remakeConstraints {
                   $0.leading.equalToSuperview()
                   $0.trailing.equalToSuperview()
                   $0.height.equalTo(size.height+22)
                   $0.width.equalTo(size.width)
               }
            
           } else {
               closeButton.isHidden = true
               zalupkaView.isHidden = false
               translationView.webView.scrollView.contentSize = size
//               translationView.snp.remakeConstraints {
//                   $0.centerY.equalToSuperview()
//                   $0.leading.trailing.equalToSuperview()
//                   $0.height.equalTo(height)
//               }
               
               contentView.snp.remakeConstraints { make in
                   make.leading.equalToSuperview()
                   make.trailing.equalToSuperview()
                   make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                   make.height.equalTo(height + 30)
               }
               
               translationView.snp.remakeConstraints {
                   
                   $0.leading.trailing.equalToSuperview()
                   $0.height.equalTo(height)
                   $0.bottom.equalToSuperview()
               }
               if hasClickedDismiss {
               coordinator.animate(alongsideTransition: nil) { _ in
                   self.dismiss(animated: true)
                 }
               }
               
           }
        remakeConstraints()
       }
    

    @objc func didClickDismiss() {
        
        hasClickedDismiss = true
        AppUtility.lockOrientation(.portrait)
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        
        if UIDevice.current.orientation.isPortrait {
            self.dismiss(animated: true)
        }
        
        
    }
    
    @objc func didClickVolume() {
        
    }
    
    @objc func didClickFullScreen() {
        if UIDevice.current.orientation.isPortrait {
    
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    
        }else{
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    
    func remakeConstraints() {
        if UIDevice.current.orientation.isPortrait {
            
//            volumeButton.snp.remakeConstraints { make in
//                make.bottom.equalToSuperview().offset(-16)
//                make.trailing.equalToSuperview().offset(-16)
//                make.width.equalTo(24)
//                make.height.equalTo(24)
//            }
            
            fullscreenButton.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-16)
                make.leading.equalToSuperview().offset(16)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
        }else{
            
            fullscreenButton.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-42)
                make.leading.equalToSuperview().offset(32)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
//            volumeButton.snp.remakeConstraints { make in
//                make.bottom.equalToSuperview().offset(-42)
//                make.trailing.equalToSuperview().offset(-48)
//                make.width.equalTo(24)
//                make.height.equalTo(24)
//            }
        }
    }
    
}
