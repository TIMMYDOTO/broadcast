//
//  StorageServiceDependencyImpl.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 20.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

fileprivate let service = StorageService()

extension StorageServiceDependency {
    var storage: StorageServiceInterface {
        return service
    }
}
