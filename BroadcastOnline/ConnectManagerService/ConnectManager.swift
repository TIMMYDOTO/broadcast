//
//  ConnectManager.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 30.07.2021.
//

import Reachability
import RxSwift
import UIKit

class ConnectManager: ConnectManagerInterface {
    
    private var reachability: Reachability!
    
    private var isConected: Bool = false {
        didSet {
            if oldValue != isConected { subject.onNext(isConected) }
        }
    }
    
    var connect: Observable<Bool> { return subject.asObserver().filter { return $0 }.map{ return $0 } }
    
    fileprivate let subject = PublishSubject<Bool>()
    
    
    init() {
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
    
    func checkIsConnected() -> Bool { isConected }
    
}

private extension ConnectManager {
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .cellular, .wifi:
            isConected = true
        case .none, .unavailable:
            isConected = false
        }
    }
    
}
