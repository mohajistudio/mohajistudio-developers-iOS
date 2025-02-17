//
//  UserRepository.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/14/25.
//

import Foundation

protocol UserRepositoryProtocol: AnyObject {
//    func getSimpleUserInfo() async throws -> UserDetailResponse
}

final class UserRepository: UserRepositoryProtocol {
    
//    func getSimpleUserInfo() async throws -> UserDetailResponse {
    
//    }
    
    private func handleError(_ data: Data) throws -> NetworkError {
        print("Error response data:", String(data: data, encoding: .utf8) ?? "")
        
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
        case "R0005":
            return .passwordNotSet
        case "R0006":
            return .profileNameNotSet
            
        default:
            return .unknown(errorResponse.message)
        }
    }

}


