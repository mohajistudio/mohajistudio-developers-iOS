//
//  SideMenuViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import Foundation
import JWTDecode

enum MenuItem {
    case myBlog
    case drafts
    case settings
    case logout
    
    var title: String {
        switch self {
        case .myBlog: return "내 블로그"
        case .drafts: return "임시글"
        case .settings: return "설정"
        case .logout: return "로그아웃"
        }
    }
}

class SideMenuViewModel {
    
    var isLoggedIn: Bool {
        return KeychainHelper.shared.getAccessToken() != nil
    }
    
    var menuItems: [MenuItem] {
        if isLoggedIn {
            return [.myBlog, .drafts, .settings, .logout]
        } else {
            return [.settings]
        }
    }
    
    func decodeUserInfoFromToken() -> SimpleUserInfo? {
        guard let token = KeychainHelper.shared.getAccessToken(),
              let jwt = try? decode(jwt: token),
              let payload = jwt.body as? [String: Any],
              let userInfo = payload["user"] as? [String: Any] else {
            return nil
        }
        
        // user 객체에서 정보 추출
        guard let userId = userInfo["id"] as? String,
              let nickname = userInfo["nickname"] as? String,
              let role = userInfo["role"] as? String,
              let email = userInfo["email"] as? String else {
            return nil
        }
        
        // profileImageUrl은 옵셔널
        let profileImageUrl = userInfo["profileImageUrl"] as? String
        
        let simpleUserInfo = SimpleUserInfo(nickname: nickname,
                                          role: role,
                                          profileImage: profileImageUrl,
                                          id: userId,
                                          email: email)
        UserDefaultsManager.shared.saveUserInfo(simpleUserInfo)
        
        return simpleUserInfo
    }
    
    var userInfo: SimpleUserInfo? {
        guard let userInfo = UserDefaultsManager.shared.getUserInfo() else {
            return decodeUserInfoFromToken()
        }
        
        return userInfo
    }
    
    var developers: [User] = [
    User(id: "1", nickname: "송규섭", email: "sks565075@gmail.com", profileImageUrl: "", role: "iOS Developer"),
    User(id: "2", nickname: "한창희", email: "", profileImageUrl: "", role: "Backend Developer"),
    User(id: "3", nickname: "이찬호", email: "", profileImageUrl: "", role: "Frontend Developer"),
    User(id: "4", nickname: "최민성", email: "", profileImageUrl: "", role: "Backend Developer"),
    User(id: "5", nickname: "최영민", email: "", profileImageUrl: "", role: "Backend Developer"),
    User(id: "6", nickname: "배지환", email: "", profileImageUrl: "", role: "Backend Developer"),
    User(id: "7", nickname: "문광운", email: "", profileImageUrl: "", role: "UI UX Designer"),
    ]

}
