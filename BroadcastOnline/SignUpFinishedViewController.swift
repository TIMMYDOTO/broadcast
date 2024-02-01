//
//  SignUpFinishedViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 21.12.2023.
//

import UIKit

class SignUpFinishedViewController: UIViewController {
    
    @IBOutlet weak var goToMainButton: UIButton!{
        didSet{
            goToMainButton.clipsToBounds = true
            goToMainButton.layer.cornerRadius = 12
            goToMainButton.enbaleButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
     
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToMain(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
