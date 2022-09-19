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
    }
    
}
