//
//  RegisterEmailVerifyCodeResponse.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/18/25.
//

import Foundation

struct RequestEmailCodeResponse: Decodable {
    let expiredAt: String
}
