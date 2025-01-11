//
//  SignUpViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import Foundation
import Alamofire

final class SignUpViewModel {
    // MARK: - Properties
    private let authRepository: AuthRepositoryProtocol
    private(set) var currentEmail: String?
    private var tokens: AuthTokenResponse?
    
    // Timer Properties
    private var timer: Timer?
    private var remainingTime: Int = 300
    var onTimerUpdate: ((String) -> Void)?
    var onTimerFinished: (() -> Void)?
    
    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
}

// MARK: - Email Management
extension SignUpViewModel {
    func setEmail(_ email: String) {
        self.currentEmail = email
    }
    
    func getCurrentEmail() -> String? {
        return currentEmail
    }
}

// MARK: - Timer Management
extension SignUpViewModel {
    var timeString: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        timer?.invalidate()
        remainingTime = 300
        updateTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.updateTimer()
        })
    }
    
    private func updateTimer() {
        if remainingTime <= 0 {
            timer?.invalidate()
            timer = nil
            onTimerFinished?()
        }
        
        onTimerUpdate?(timeString)
        print(timeString)
        remainingTime -= 1
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - API Calls
extension SignUpViewModel {
    func requestEmailVerification(email: String) async throws {
        try await authRepository.requestEmailVerification(email: email)
    }
    
    func verifyEmailCode(code: String) async throws {
        guard let email = currentEmail else {
            throw NetworkError.unknown("인증할 이메일이 입력되지 않았습니다.")
        }
        
        tokens = try await authRepository.verifyEmailCode(email: email, code: code)
        // 토큰 처리 로직
        if let tokens = tokens {
            KeychainHelper.shared.saveAccessToken(tokens.accessToken)
            KeychainHelper.shared.saveRefreshToken(tokens.refreshToken)
        }
        
        print("이메일 인증 - 토큰 저장 완료")
    }
    
    func setPassword(password: String) async throws {
        try await authRepository.setPassword(password: password)
    }
    
    func setNickname(nickname: String) async throws {
        try await authRepository.setNickname(nickname: nickname)
    }
}
