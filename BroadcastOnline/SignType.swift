//
//  SignType.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 01.12.2023.
//

import Foundation

struct SignTypeItem {
    var title: String
    
}

enum SignType: String {
    case signUp
    case signIn

    
    func getModel() -> SignTypeItem {
        
        switch self {
        case .signUp: return SignTypeItem(title: "Регистрация")
        case .signIn: return SignTypeItem(title: "Авторизация")
 

        }
    }
    

}
