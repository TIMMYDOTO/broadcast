//
//  NewPasswordViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 20.12.2023.
//

import UIKit

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var acceptButton: UIButton!{
        didSet{
            
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

    @IBAction func didTapAcceptButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NewPasswordFinishedViewController") as! NewPasswordFinishedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
