//
//  BroadcastViewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 14.09.2022.
//

import UIKit
import PIPKit
class BroadcastViewController: UIViewController, PIPUsable {
    var pipSize: CGSize { return CGSize(width: (UIScreen.main.bounds.width / 3) * 2 , height:  (UIScreen.main.bounds.width / 3) * 2 * 0.5625) }
    var closeButton: UIButton!
    var fullscreenButton: UIButton!
    
    private weak var translationView: CSDetailsHeaderTranslationView!
    var hasClickedDismiss = false
    var match: CSMatch!
    var viewTranslation = CGPoint(x: 0, y: 0)
    let height = UIScreen.main.bounds.width * 0.5625
    private weak var contentView: UIView!
    private weak var zalupkaView: UIView!
    private weak var huitaView: UIView!
    
    var myInterfaceOrientation = UIInterfaceOrientation(rawValue: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        
        setupTranslationView()
        translationView.configure(match.stream)
        setupCloseButton()
        
        
        setupFullscreenButton()
        addZalupkaView()
        addHuitaView()
        

        }

    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.all)
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
    
    private func addHuitaView() {
        let view = UIView()
    
        huitaView = view
        self.view.addSubview(huitaView)
        huitaView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(zalupkaView.snp.top).offset(-40)
            make.top.equalToSuperview().offset(8)
        }
        huitaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickOutside)))
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
        if windowInterfaceOrientation!.isPortrait {
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
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        let windowInterfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        return windowInterfaceOrientation
       
       
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
      
        
        coordinator.animate(alongsideTransition: { (context) in
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            self.myInterfaceOrientation = windowInterfaceOrientation
            if windowInterfaceOrientation.isLandscape {
                self.closeButton.isHidden = false
                self.zalupkaView.isHidden = true
                self.translationView.webView.scrollView.contentSize = size
                
                self.contentView.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                
                
                self.translationView.snp.remakeConstraints {
                    $0.leading.equalToSuperview()
                    $0.trailing.equalToSuperview()
                    $0.height.equalTo(size.height+22)
                    $0.width.equalTo(size.width)
                }
            } else {
                self.closeButton.isHidden = true
                self.zalupkaView.isHidden = false
                self.translationView.webView.scrollView.contentSize = size
                
                
                self.contentView.snp.remakeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    make.height.equalTo(self.height + 30)
                }
                
                self.translationView.snp.remakeConstraints {
                    
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(self.height)
                    $0.bottom.equalToSuperview()
                }
                if self.hasClickedDismiss {
                    coordinator.animate(alongsideTransition: nil) { _ in
                        self.dismiss(animated: true)
                    }
                }
            }
            self.remakeConstraints(orientation: windowInterfaceOrientation)
        })
        

    
       }
    
    @objc func didClickOutside() {
        AppUtility.lockOrientation(.portrait)
        dismiss(animated: true)
    }
    
    @objc func didClickDismiss() {
        
        hasClickedDismiss = true
        AppUtility.rotateTo(.portrait)
        AppUtility.lockOrientation(.portrait)
     
        
    
        
    }
    
  
    
    @objc func didClickFullScreen() {
        
        if myInterfaceOrientation!.isPortrait {

            AppUtility.rotateTo(.landscapeLeft)
        }else{

            AppUtility.rotateTo(.portrait)
        }

        
    }
    
    func remakeConstraints(orientation: UIInterfaceOrientation) {
        if orientation.isPortrait {
            
            
            fullscreenButton.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-16)
                make.leading.equalToSuperview().offset(16)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
        }else{
            
            fullscreenButton.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-42)
                make.leading.equalToSuperview().offset(42)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            

        }
    }
    
}
