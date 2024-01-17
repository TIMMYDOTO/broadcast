//
//  ButtonWithLoader.swift
//  BetBoom
//
//  Created by Владимир Занков on 27.01.2023.
//

import UIKit

class ButtonWithLoader: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ai = UIActivityIndicatorView()
        ai.color = UIColor(hex: "#0D0D0D")
        ai.hidesWhenStopped = true
        addSubview(ai)
        ai.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel!.snp.centerY)
            $0.trailing.equalTo(self.titleLabel!.snp.leading).offset(-10)
        }
        
        self.activityIndicator = ai
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        isUserInteractionEnabled = false
        activityIndicator?.startAnimating()
    }
    
    func stopLoading() {
        isUserInteractionEnabled = true
        activityIndicator?.stopAnimating()
    }
}
