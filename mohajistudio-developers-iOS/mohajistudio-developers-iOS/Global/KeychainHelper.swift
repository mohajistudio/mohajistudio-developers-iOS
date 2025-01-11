//
//  KeyChainHelper.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/30/24.
//

import Foundation
import SwiftKeychainWrapper

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    func saveAccessToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: "mohaji_accessToken")
    }
    
    func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "mohaji_accessToken")
    }
    
    func saveRefreshToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: "mohaji_refreshToken")
    }
    
    func getRefreshToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "mohaji_refreshToken")
    }
    
    func clearTokens() {
        KeychainWrapper.standard.removeObject(forKey: "mohaji_accessToken")
        KeychainWrapper.standard.removeObject(forKey: "mohaji_refreshToken")
    }
    
}
