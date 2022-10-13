//
//  CheckVersion.swift
//  BetBoom
//
//  Created by Козлов Виталий Алексеевич on 11.11.2021.
//
import Foundation
import Alamofire

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
    var releaseNotes: String
}

class AppInfoNative: Decodable {
    var version: String
    var message: String?
}


class CheckUpdate: NSObject {

    static let shared = CheckUpdate()
    
    var versionInAppStore = ""
    var versionNative = ""
    var versionApp = ""
    
    func showUpdate(_ completion: @escaping (AppInfo?, AppInfoNative?) -> ()) {
        DispatchQueue.global().async {
            self.checkVersion() {[weak self] info in
                print(info)
                _ = self?.getAppInfoNative(completion: { infoNative, error in
                    guard let infoNative = infoNative else { return }
                    completion(info, infoNative)
                    print()
                })
            }
        }
    }
  

    private  func checkVersion( _ completion: @escaping (AppInfo?) -> ()) {
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString") {
            versionApp = currentVersion
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version {
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion <= currentVersion {
                        print("Already on the last app version: ",currentVersion)
                    } else {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                        completion(info)
                    }
                }
            }
        }
        
    }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
    
      // You should pay attention on the country that your app is located, in my case I put Brazil */br/*
      // Você deve prestar atenção em que país o app está disponível, no meu caso eu coloquei Brasil */br/*
      
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "http://itunes.apple.com/ru/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
          
            
                do {
                    if let error = error { throw error }
                    guard let data = data else { throw VersionError.invalidResponse }
                    
                    let result = try JSONDecoder().decode(LookupResult.self, from: data)
                    print(result.results)
                    self?.versionInAppStore = result.results.first?.version ?? "1"
                    guard let info = result.results.first else {
                        throw VersionError.invalidResponse
                    }

                    completion(info, nil)
                } catch {
                    completion(nil, error)
                }
            }
        
        task.resume()
        return task

    }
    
    func getAppConfig(endpoint: AppConfigEndpoint, completion: @escaping (Bb_IosConfig?, Error?) -> Void) {
        let urlString = endpoint.rawValue
        guard let _ = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil, VersionError.invalidBundleInfo)
            }
            return
        }
        AF.request(urlString)
            .validate()
            .responseData(completionHandler: { (response) in
                
            guard let data = response.data else { return }
            let result = try? Bb_IosConfig(serializedData: data)
            completion(result, nil)
        })
    }
    /*
    func getAppConfig(completion: @escaping (Bb_IosConfig?, Error?) -> Void) {
        guard let _ = URL(string: "https://static.betboom.ru/a42b6c0d962d129e2d235de49f7c4173/mobile_app_config/ios_config")

        else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
            return
        }
        AF.request("https://static.betboom.ru/a42b6c0d962d129e2d235de49f7c4173/mobile_app_config/ios_config")
            .validate()
            .responseData(completionHandler: {(response) in
                
                guard let data = response.data else { return }
                let result = try? Bb_IosConfig(serializedData: data)
                completion(result, nil)
            })
    }
    
    func getAppConfigYandex(completion: @escaping (Bb_IosConfig?, Error?) -> Void) {
        guard let _ = URL(string: "https://static.betboom.ru/726c4e6ba30fda46a939b6a0879b46c4/ios_config")
        else {
            DispatchQueue.main.async {
                completion(nil, VersionError.invalidBundleInfo)
            }
            return
        }
        
        AF.request("https://static.betboom.ru/726c4e6ba30fda46a939b6a0879b46c4/ios_config")
            .validate()
            .responseData(completionHandler: {(response) in
                
                guard let data = response.data else { return }
                let result = try? Bb_IosConfig(serializedData: data)
                completion(result, nil)
            })
    }
     */
    private func getAppInfoNative(completion: @escaping (AppInfoNative?, Error?) -> Void) -> URLSessionDataTask? {
    
      // You should pay attention on the country that your app is located, in my case I put Brazil */br/*
      // Você deve prestar atenção em que país o app está disponível, no meu caso eu coloquei Brasil */br/*
      
        guard let url = URL(string: AppDataStore.shared.appConfig.versionFile) else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
            let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
              
                
                    do {
                        if let error = error { throw error }
                        guard let data = data else { throw VersionError.invalidResponse }
                        
                        let result = try JSONDecoder().decode(AppInfoNative.self, from: data)
                        print(result)
                        self?.versionNative = result.version
                        completion(result, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            
            task.resume()
            return task
        }

    func checkNewVersion() -> (Bool, String?) {
        if versionInAppStore == versionNative {
            return (versionNative > versionApp, versionInAppStore)
        } else {
            return (false, nil)
        }
    }

    func getBundle(key: String) -> String? {

        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
}

enum AppConfigEndpoint: String {
    case google = "https://static.betboom.ru/a42b6c0d962d129e2d235de49f7c4173/mobile_app_config/ios_config"
    case yandex = "https://mobile.betboom.ru/ios_config"
    case testGoogle = "https://static.betboom.ru/a42b6c0d962d129e2d235de49f7c4173/mobile_app_config/test_ios_config"
    case testYandex = "https://static.betboom.ru/726c4e6ba30fda46a939b6a0879b46c4/test_ios_config"
}
