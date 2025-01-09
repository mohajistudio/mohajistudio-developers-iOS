//
//  HTTPHeaderFields.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation

enum HTTPHeaderFields {
    case applicationJSON
    case multipartFormData
    case custom([String: String])
    
    var headers: [String: String] {
        switch self {
        case .applicationJSON:
            return ["Content-Type": "application/json"]
        case .multipartFormData:
            return ["Content-Type": "multipart/form-data"]
        case .custom(let headers):
            return headers
        }
    }
}
