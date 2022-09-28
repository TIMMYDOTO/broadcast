//
//  NavigationController.swift
//  BroadcastOnline
//
//  Created by Artyom on 15.09.2022.
//

import UIKit
import Reachability
class NavigationController: UINavigationController {
    private weak var noConnectionVC: NoConnectionViewController?
    private var reachability: Reachability!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
//        setupNoConnection()

        
    }
    
    
    
    private func setupNoConnection() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(reachabilityChanged(note:)),
                name: NSNotification.Name.reachabilityChanged,
                object: nil
            )
        
        reachability = try! Reachability()
        
        do
        {
            try reachability.startNotifier()
        }
        catch
        {
            print( "ERROR: Could not start reachability notifier." )
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .cellular, .wifi:
            self.noConnectionVC?.dismiss(animated: false, completion: nil)
            self.noConnectionVC = nil
            
        case .none, .unavailable:
            if self.noConnectionVC != nil { return }
            if let topVC = UIApplication.getTopViewController() {
               topVC.dismiss(animated: true)
            }
            let vc = NoConnectionViewController()
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: false, completion: nil)
            self.noConnectionVC = vc
        }
    }

}



extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
