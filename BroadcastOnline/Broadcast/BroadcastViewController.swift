//
//  BroadcastViewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 14.09.2022.
//

import UIKit

class BroadcastViewController: UIViewController {
    
    var closeButton: UIButton!

    private weak var translationView: CSDetailsHeaderTranslationView!
    
    var match: CSMatch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupTranslationView()
        translationView.configure(match.stream)
        setupCloseButton()
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.all)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
   }
    
    
    private func setupCloseButton() {
        let image = UIImage(named: "CloseIcon")
        let button = UIButton()
        button.setImage(image, for: .normal)
        closeButton = button
        view.addSubview(closeButton)
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
        view.addSubview(translationView)

        translationView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 0.5625)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           if UIDevice.current.orientation.isLandscape {
               translationView.snp.remakeConstraints {
                   $0.leading.equalToSuperview()
                   $0.trailing.equalToSuperview()
                   $0.height.equalTo(size.height)
                   $0.width.equalTo(size.width)
               }

           } else {

               translationView.snp.remakeConstraints {
                   $0.centerY.equalToSuperview()
                   $0.leading.trailing.equalToSuperview()
                   $0.height.equalTo(UIScreen.main.bounds.width * 0.5625)
               }
           }
       }
    

    @objc func didClickDismiss() {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        AppUtility.lockOrientation(.portrait)
        dismiss(animated: true)
    }
    
}
