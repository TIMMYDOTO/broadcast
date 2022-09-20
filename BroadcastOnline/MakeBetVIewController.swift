//
//  MakeBetVIewController.swift
//  BroadcastOnline
//
//  Created by Artyom on 15.09.2022.
//

import UIKit

class MakeBetVIewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!{
        didSet{
            backgroundView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var zalupkaView: UIView!{
        didSet{
            zalupkaView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var makeBetButton: UIButton!{
        didSet{
            makeBetButton.layer.cornerRadius = 12
            makeBetButton.clipsToBounds = true
            let firstColor = #colorLiteral(red: 1, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
            let secondColor = #colorLiteral(red: 1, green: 0.5137254902, blue: 0.3058823529, alpha: 1)
            self.makeBetButton.applyGradient(colours: [firstColor, secondColor])
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func didTapmakeBet(_ sender: UIButton) {
        let locale = Locale.current
        
        if locale.regionCode == "RU" {
             let url = URL(string: "https://apps.apple.com/ru/app/betboom-%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B8-%D0%BD%D0%B0-%D1%81%D0%BF%D0%BE%D1%80%D1%82/id1523280942")!
                UIApplication.shared.open(url)
            
                
            }else{
                 let url = URL(string: "https://bbnew.onelink.me/UB93/8knyuz7m")!
                    UIApplication.shared.open(url)
                
            
        }
        
    }
}
