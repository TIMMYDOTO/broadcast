//
//  ViewInput.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 28.09.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import Foundation

protocol ViewInput: NSObjectProtocol, Presentable {
    func showLoader()
    func hideLoader()
}
