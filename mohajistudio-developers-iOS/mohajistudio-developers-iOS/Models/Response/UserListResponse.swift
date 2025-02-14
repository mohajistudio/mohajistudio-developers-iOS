//
//  UserListResponse.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import Foundation

struct UserListResponse: Decodable {
    let page: Int
    let content: [User]?
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}

struct User: Decodable {
    let id: String
    let nickname: String
    let email: String
    let profileImageUrl: String
    let role: String
}
