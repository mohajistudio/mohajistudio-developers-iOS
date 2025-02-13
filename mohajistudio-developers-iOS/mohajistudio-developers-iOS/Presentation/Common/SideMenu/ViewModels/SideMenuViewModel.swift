//
//  SideMenuViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import Foundation

class SideMenuViewModel {
    var notLoggedInMenuItems = ["설정"]
    var menuItems: [String] = ["내 블로그", "임시글", "설정", "로그아웃"]
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
