//
//  UserDefaultsManager.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/14/25.
//

import Foundation

struct SimpleUserInfo: Codable {
    let nickname: String
    let role: String
    let profileImage: String?
    let id: String
    let email: String
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userInfoKey = "userInfo"
    
    func saveUserInfo(_ userInfo: SimpleUserInfo) {
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: userInfoKey)
        }
    }
    
    func getUserInfo() -> SimpleUserInfo? {
        guard let data = UserDefaults.standard.data(forKey: userInfoKey),
              let userInfo = try? JSONDecoder().decode(SimpleUserInfo.self, from: data) else {
            return nil
        }
        return userInfo
    }
    
    func clearUserInfo() {
        UserDefaults.standard.removeObject(forKey: userInfoKey)
    }
}
