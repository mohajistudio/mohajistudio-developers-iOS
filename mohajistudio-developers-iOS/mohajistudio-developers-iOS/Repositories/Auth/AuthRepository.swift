//
//  AuthRepository.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation
import Alamofire

protocol AuthRepositoryProtocol {
    func requestEmailVerification(email: String) async throws
    func verifyEmailCode(email: String, code: String) async throws -> AuthTokenResponse
    func setPassword(password: String) async throws
    func setNickname(nickname: String) async throws
}

final class AuthRepository: AuthRepositoryProtocol {
    
    func requestEmailVerification(email: String) async throws {
        let request = EmailVerificationRequest(email: email)
        
        let response = try await AF.request(AuthRouter.requestEmailVerification(request))
            .serializingResponse(using: .data)
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        switch statusCode {
        case 200:
            return
        default:
            if let data = response.data {
                throw try handleError(data)
            } else {
                throw NetworkError.invalidResponse
            }
        }
        
    }
    
    func verifyEmailCode(email: String, code: String) async throws -> AuthTokenResponse {
        let request = EmailCodeVerificationRequest(email: email, code: code)
        
        let response = try await AF.request(AuthRouter.verifyEmailCode(request))
            .serializingResponse(using: .data)
            .response
        
        debugPrint(response)
        
        if response.response?.statusCode == 200 {
            guard let data = response.data else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
            return try decoder.decode(AuthTokenResponse.self, from: data)
        }
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        throw try handleError(data)
    }
    
    func setPassword(password: String) async throws {
        
        let request = SetPasswordRequest(password: password)
        
        let response = try await AF.request(AuthRouter.setPassword(request), interceptor: AuthInterceptor())
            .serializingResponse(using: .data)
            .response
        
        debugPrint(response)
        
        if response.response?.statusCode == 200 {
            return
        }
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        throw try handleError(data)
        
    }
    
    func setNickname(nickname: String) async throws {
        
        let request = SetNicknameRequest(nickname: nickname)
        
        let response = try await AF.request(AuthRouter.setNickname(request), interceptor: AuthInterceptor())
            .serializingResponse(using: .data)
            .response
        
        print("\(response)")
        
        if response.response?.statusCode == 200 {
            return
        }
        
        guard let data = response.data else {
            throw NetworkError.invalidResponse
        }
        
        throw try handleError(data)
        
    }
    
    
    // MARK: - auth 관련 에러 handle
    private func handleError(_ data: Data) throws -> NetworkError {
        struct ErrorResponse: Decodable {
            let code: String
            let message: String
        }
        
        let decoder = JSONDecoder()
        guard let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) else {
            return .unknown("unknown error ocurred")
        }
        
        switch errorResponse.code {
        case "R0001":
            return .alreadyRegistered
        case "R0002":
            return .passwordAlreadyExists
        case "EV004":
            return .tooManyRequestCode
        case "EV0001":
            return .failedToSendEmail
        case "EV0002":
            return .notValidCode
        case "EV0003":
            return .tooManyAttempts
        case "U0001":
            return .unknownUser
            
        default:
            return .unknown(errorResponse.message)
        }
    }
}

// 코드 발급 EV004: 인증 메일 요청 횟수 초과, EV0001: 이메일 전송 실패, R0001: 이미 존재하는 유저
// 코드 인증 EV0002: 유효하지 않은 이메일, EV0003: 이메일 인증 횟수 초과, R0001: 이미 존재하는 유저
// 비번 설정 U0001: 알 수 없는 유저, R0002: 이미 설정된 비밀번호, R0001: 이미 존재하는 유저
// 사용자 전용 메시지는 후에 설정, 기획
