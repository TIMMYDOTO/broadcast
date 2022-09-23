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
    var viewTranslation = CGPoint(x: 0, y: 0)
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
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
  
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundView.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
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
