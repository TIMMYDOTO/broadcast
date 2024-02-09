//
//  NewPasswordViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 20.12.2023.
//

import UIKit

class NewPasswordViewController: UIViewController, ApiServiceDependency {

    @IBOutlet weak var firstPasswordTextField: PasswordTextField!{
        didSet{
            firstPasswordTextField.placeholderLayer.string = "Введи новый пароль *"
        }
    }
    
    @IBOutlet weak var secondPasswordTextField: PasswordTextField!{
        didSet{
            secondPasswordTextField.placeholderLayer.string = "Повтори новый пароль *"
        }
    }
    
    @IBOutlet weak var acceptButton: UIButton!{
        didSet{
            acceptButton.clipsToBounds = true
            acceptButton.layer.cornerRadius = 12
            acceptButton.disableButton()
        }
    }
    
    var sessionId: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        binding()
    }
    
    func binding() {
        firstPasswordTextField.didChangeEditing = {  [weak self] str in
            self?.checkFields()
        }
        
        secondPasswordTextField.didChangeEditing = {  [weak self] str in
            self?.checkFields()
        }
    }
    
    func checkFields() {
        let firstPassword = firstPasswordTextField.textField.text ?? ""
        let secondPassword = secondPasswordTextField.textField.text ?? ""
        
        if firstPassword.count == secondPassword.count && 
            !firstPassword.isEmpty &&
            !secondPassword.isEmpty &&
            firstPassword.count >= 8 &&
            secondPassword.count >= 8{
            acceptButton.enbaleButton()
        }else{
            acceptButton.disableButton()
        }
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

    @IBAction func didTapAcceptButton(_ sender: UIButton) {
        let firstPassword = firstPasswordTextField.textField.text ?? ""
        let secondPassword = secondPasswordTextField.textField.text ?? ""
        if firstPassword != secondPassword {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
        }else{
            let paasword = firstPasswordTextField.textField.text ?? ""
            api.newPassword(password: paasword, sessionId: sessionId) { result in
                if case .success(let success) = result {
                    print("success", success)
                    self.moveToFinishedViewController()
                    
                }else{
                    print("failure")
                }
            }
        }
        
    }
    
    func moveToFinishedViewController() {
        let vc = storyboard?.instantiateViewController(identifier: "NewPasswordFinishedViewController") as! NewPasswordFinishedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
