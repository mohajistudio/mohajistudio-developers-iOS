//
//  AuthRouter.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case checkSignUpStatus(String)
    case requestEmailVerification(EmailVerificationRequest)
    case verifyEmailCode(EmailCodeVerificationRequest)
    case refreshToken(RefreshTokenRequest)
    case setPassword(SetPasswordRequest)
    case setNickname(SetNicknameRequest)
    
    case login(LoginRequest)
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
        case .checkSignUpStatus:
            return "/auth/register/status"
        case .requestEmailVerification:
            return "/auth/register/email-verification/request"
        case .verifyEmailCode:
            return "/auth/register/email-verification/verify"
        case .refreshToken:
            return "/auth/refresh"
        case .setPassword:
            return "/auth/register/password"
        case .setNickname:
            return "/auth/register/nickname"
        case .login:
            return "/auth/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkSignUpStatus:
            return .get
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
        case .login:
            return .post
        }
    }
    
    var headers: HTTPHeaderFields {
        switch self {
        case .checkSignUpStatus:
            return .applicationJSON
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
        case .login:
            return .applicationJSON
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .checkSignUpStatus(let email):
            return ["email": email]
        case .requestEmailVerification,
             .verifyEmailCode,
             .refreshToken,
             .setPassword,
             .setNickname,
             .login:
            return nil
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
        case .checkSignUpStatus:
            return try URLEncoding.default.encode(request, with: parameters)
            
        case .requestEmailVerification(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        case .verifyEmailCode(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        case .refreshToken(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        case .setPassword(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        case .setNickname(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        case .login(let requestModel):
            request.httpBody = try JSONEncoder().encode(requestModel)
        }
        
        return request
    }

}
