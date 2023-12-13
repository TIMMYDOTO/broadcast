//
//  TextField.swift
//  
//
//  Created by Шкёпу Артём Вячеславович on 30.11.2023.
//

import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
