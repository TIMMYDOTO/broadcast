//
//  StorageServiceInterface.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

protocol StorageServiceInterface {
    func integer(forKey defaultName: String) -> Int
    func float(forKey defaultName: String) -> Float
    func double(forKey defaultName: String) -> Double
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func object(forKey defaultName: String) -> Any?
    
    func set(_ value: Int, forKey defaultName: String)
    func set(_ value: Float, forKey defaultName: String)
    func set(_ value: Double, forKey defaultName: String)
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    
    func remove(forKey defaultName: String)
    
    
    //
    func object(key: UserDefaultKey) -> Any?
    
    func set(_ value: Any?, key: UserDefaultKey)
    
    func remove(key: UserDefaultKey)
    
    func set(_ value: Double, forKey defaultName: UserDefaultKey)
    
    func set(_ value: Bool, forKey defaultName: UserDefaultKey)
    
    func set(_ value: Int, forKey defaultName: UserDefaultKey)
    
    func set(_ value: String, forKey defaultName: UserDefaultKey)
    
    func double(forKey defaultName: UserDefaultKey) -> Double
    
    func bool(forKey defaultName: UserDefaultKey) -> Bool
    
    func integer(forKey defaultName: UserDefaultKey) -> Int
    
    func string(forKey defaultName: UserDefaultKey) -> String?
    
}
