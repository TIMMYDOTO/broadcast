//
//  ApiServiceDependencyImpl.swift
//  BetBoom
//
//  Created by Sergey Lezhnev on 16.07.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//


import Foundation

fileprivate let apiService = ProtobufService(
//    baseUrl: "https://mobileappv2.betboom.ru/api/mobile/v2",
//    baseUrl: "https://market-cyb.bb-online-stage.com/api/mobile/v1",
    baseUrl: "https://betmarket.dev/api/mobile/v1/",
    contentUrl: "https://bboncyp-newapp.bb-online-stage.com"
)

//https://mobileappv2.bboncyp-newapp.bb-online-stage.com/api/mobile/v2
extension ApiServiceDependency {
    var api: ApiServiceInterface {
        
        return apiService
    }
}
