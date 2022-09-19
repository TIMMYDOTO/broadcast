//
//  ViewOutput.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 02.10.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

protocol ViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
}

extension ViewOutput {
    func viewDidLoad() {}
    func viewWillAppear(animated: Bool) {}
    func viewDidAppear(animated: Bool) {}
    func viewWillDisappear(animated: Bool) {}
    func viewDidDisappear(animated: Bool) {}
}
