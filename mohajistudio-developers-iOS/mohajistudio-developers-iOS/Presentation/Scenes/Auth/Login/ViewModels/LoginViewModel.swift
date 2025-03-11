//
//  LoginViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import Foundation

final class LoginViewModel {
    
    private let authRepository: AuthRepositoryProtocol
    private var tokens: AuthTokenResponse?
    
    private(set) var email: String = ""
    private(set) var password: String = ""
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
}
    // MARK: - Business Logic
    
extension LoginViewModel {
    
    func login() async throws {
        guard !email.isEmpty else {
            print("email is nil")
            throw NetworkError.unknown("이메일 입력 오류")
        }
        
        tokens = try await authRepository.login(email: email, password: password)
        
        if let tokens = tokens {
            KeychainHelper.shared.saveAccessToken(tokens.accessToken)
            KeychainHelper.shared.saveRefreshToken(tokens.refreshToken)
        }
        
        print("로그인 - 토큰 저장 완료")
    }
    
}
