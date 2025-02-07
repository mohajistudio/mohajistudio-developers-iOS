//
//  UserDetailResponse.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/7/25.
//

import Foundation

struct UserDetailResponse: Decodable {
    let id: String
    let nickname: String
    let email: String
    let profileImageUrl: String?
    let bio: String
    let role: String
    let contacts: [Contact]?
}

struct Contact: Decodable {
    let id: String
    let name: String
    let imageUrl: String
    let displayName: String
    let url: String
}
