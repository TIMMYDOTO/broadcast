//
//  BBCheckBox.swift
//  BetBoom
//
//  Created by Шкёпу Артём Вячеславович on 17.12.2020.
//

import UIKit

class BBCheckBox: UIButton {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 16, height: 16)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -12, dy: -12).contains(point)
    }
    
    
    private func setup() {
        setImage(#imageLiteral(resourceName: "CheckBoxEmpty"), for: .normal)
        setImage(#imageLiteral(resourceName: "checkbox"), for: .selected)
        imageEdgeInsets = .zero
        tintColor = .clear
    }
}
