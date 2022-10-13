//
//  AppConfig.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 01.06.2022.
//

import Foundation

struct AppConfig {
    var versionFile = String()
    var prodNamespace = String()
    var prodSchemes = [String]()
    var testNamespaceSuffix = String()
    var apiUrl = String()
    var mobileAppWsUrl = String()
    var sportTreeWsUrl = String()
    var esportTreeWsUrl = String()
    var sportRadarUrl = String()
    var isSupportOddin = false
    var webimAccount = String()
    
    var apiUrlProd = String()
    var mobileAppWsUrlProd = String()
    var esportTreeWsUrlProd = String()
    var sportTreeWsUrlProd = String()
    
    
    mutating func configure(_ data: Bb_IosConfig, with: (namespace: String, scheme: String)?) {
        prodSchemes = data.prodSchemes
        versionFile = data.versionFile
        prodNamespace = data.prodNamespace
        testNamespaceSuffix = data.testNamespaceSuffix
        apiUrl = data.apiURL
        mobileAppWsUrl = data.mobileAppWsURL
        sportTreeWsUrl = data.sportTreeWsURL
        esportTreeWsUrl = data.oddinTreeWsURL
        isSupportOddin = true
        sportRadarUrl = data.sportradarURL.replacingOccurrences(of: "m${event_id}", with: "")
        webimAccount = data.webimAccount
        if let with = with {
            let namespace = with.namespace.isEmpty ? prodNamespace : with.namespace
            let schemeDash = with.scheme.isEmpty ? "" : "-"
            apiUrlProd = data.apiURL.replacingOccurrences(of: "${namespace}", with: namespace).replacingOccurrences(of: "${scheme}", with: with.scheme).replacingOccurrences(of: "${scheme_dash}", with: schemeDash)
            mobileAppWsUrlProd = data.mobileAppWsURL.replacingOccurrences(of: "${namespace}", with: namespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
            sportTreeWsUrlProd = data.sportTreeWsURL.replacingOccurrences(of: "${namespace}", with: namespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
            esportTreeWsUrlProd = data.oddinTreeWsURL.replacingOccurrences(of: "${namespace}", with: namespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
        } else {
            apiUrlProd = data.apiURL.replacingOccurrences(of: "${namespace}", with: prodNamespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dash}", with: "")
            mobileAppWsUrlProd = data.mobileAppWsURL.replacingOccurrences(of: "${namespace}", with: prodNamespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
            sportTreeWsUrlProd = data.sportTreeWsURL.replacingOccurrences(of: "${namespace}", with: prodNamespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
            esportTreeWsUrlProd = data.oddinTreeWsURL.replacingOccurrences(of: "${namespace}", with: prodNamespace).replacingOccurrences(of: "${scheme}", with: "").replacingOccurrences(of: "${scheme_dot}", with: "")
        }
    }
}
