//
//  AuthRouter.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case requestEmailVerification(EmailVerificationRequest)
    case verifyEmailCode(EmailCodeVerificationRequest)
    case refreshToken(RefreshTokenRequest)
    case setPassword(SetPasswordRequest)
    case setNickname(SetNicknameRequest)
}

extension AuthRouter: URLRequestConvertible {
    var baseURL: URL {
        guard let url = URL(string: NetworkConfiguration.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .requestEmailVerification:
            return "/auth/register/email/request"
        case .verifyEmailCode:
            return "/auth/register/email/verify"
        case .refreshToken:
            return "/auth/refresh"
        case .setPassword:
            return "/auth/register/password"
        case .setNickname:
            return "/auth/register/nickname"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestEmailVerification:
            return .post
        case .verifyEmailCode:
            return .post
        case .refreshToken:
            return .post
        case .setPassword:
            return .post
        case .setNickname:
            return .post
        }
    }
    
    var headers: HTTPHeaderFields {
        switch self {
        case .requestEmailVerification:
            return .applicationJSON
        case .verifyEmailCode:
            return .applicationJSON
        case .refreshToken:
            return .applicationJSON
        case .setPassword:
            return .applicationJSON
        case .setNickname:
            return .applicationJSON
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        headers.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        switch self {
        case .requestEmailVerification(let requestModel):
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        case .verifyEmailCode(let requestModel):
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        case .refreshToken(let requestModel):
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        case .setPassword(let requestModel):
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        case .setNickname(let requestModel):
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        }
        
        return request
    }
}
