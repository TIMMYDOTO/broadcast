//
//  NewPasswordFinishedViewController.swift
//  
//
//  Created by Шкёпу Артём Вячеславович on 21.12.2023.
//

import UIKit

class NewPasswordFinishedViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!{
        didSet{
            signInButton.layer.cornerRadius = 12
            signInButton.enbaleButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(goBack))
        backButton.theme_tintColor = ThemeColor.iconPrimary
        self.navigationItem.leftBarButtonItem = backButton
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didClickSignIn(_ sender: UIButton) {
        let viewController = navigationController?.viewControllers[safe: 1] ?? AuthViewController()
        navigationController?.popToViewController(viewController, animated: true)
    }
    
}
