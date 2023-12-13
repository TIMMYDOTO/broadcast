//
//  AuthInput.swift
//  BetBoom
//
//  Created by Занков Владимир Владимирович on 25.01.2023.
//

import Foundation

struct AuthInput<DataType: Equatable> {
    
    var isEnabled: Bool
    
    var data: DataType? = nil
    
    var validationState: AnyAuthInput.ValidationState
    
    var erased: AnyAuthInput {
        return AnyAuthInput(isEnabled: isEnabled, validationState: validationState)
    }
}

struct AnyAuthInput: Equatable {
    
    var isEnabled: Bool
    
    var validationState: ValidationState
    
    enum ValidationState: Equatable {
        case `default`
        case success
        case error
        case errorMessage(String)
        
        static func ==(lhs: ValidationState, rhs: ValidationState) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case (.default, .default):
                return true
            case (.error, .error):
                return true
            case (.errorMessage(_), .errorMessage(_)):
                return true
            default:
                return false
            }
        }
    }
}

extension AuthInput {
    
    var error: String? {
        if case .errorMessage(let message) = validationState {
            return message
        } else {
            return nil
        }
    }
}
