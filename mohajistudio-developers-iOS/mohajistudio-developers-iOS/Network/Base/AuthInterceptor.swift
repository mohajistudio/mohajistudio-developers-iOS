//
//  AuthInterceptor.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/30/24.
//

import Foundation
import Alamofire

struct AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        if let token = KeychainHelper.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard let refreshToken = KeychainHelper.shared.getRefreshToken() else {
            completion(.doNotRetry)
            return
        }
        
        // 토큰 재발급 시도
        let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)
        
        Task {
            do {
                let response = try await AF.request(AuthRouter.refreshToken(refreshRequest))
                    .serializingDecodable(AuthTokenResponse.self)
                    .value
                
                // 새로운 토큰 저장
                KeychainHelper.shared.saveAccessToken(response.accessToken)
                KeychainHelper.shared.saveRefreshToken(response.refreshToken)
                
                // 재시도
                completion(.retry)
            } catch {
                print("Token refresh failed: \(error)")
                completion(.doNotRetry)
            }
        }
    }
}
