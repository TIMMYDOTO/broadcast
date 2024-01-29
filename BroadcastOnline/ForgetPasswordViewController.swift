//
//  ForgetPasswordViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 20.12.2023.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var birthdayField: CaptchaTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var continueButton: UIButton!{
        didSet{
            continueButton.setTitleColor(#colorLiteral(red: 0.3529411765, green: 0.4274509804, blue: 0.6, alpha: 1), for: .normal)
            continueButton.disableButton()
            continueButton.layer.cornerRadius = 12
            continueButton.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var captchaImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.enbaleButton()
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
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPasswordViewController") as! NewPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
