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
    enum SignUpStatus {
        case needEmail
        case needVerification
        case needPassword
        case needProfileName
    }
    
    private let authRepository: AuthRepositoryProtocol
    private(set) var currentEmail: String?
    private var tokens: AuthTokenResponse?
    
    private var timer: Timer?
    private var remainingTime: Int = 0
    var onTimerUpdate: ((String) -> Void)?
    var onTimerFinished: (() -> Void)?
    
    private var timeString: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
    func startTimer(expirationDate: String) {
        print("[VM] startTimer 호출 - exprirationDate: \(expirationDate)")
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        print("[VM] 날짜 파싱 시도")
        print("파싱할 날짜: \(expirationDate)")
        
        var parsedDate: Date?
        
        // 1. ISO8601 포맷으로 시도
        if let date = dateFormatter.date(from: expirationDate) {
            parsedDate = date
            print("ISO8601 방식으로 날짜 파싱 성공")
        }
        // 2. 실패 시 대체 포맷으로 시도
        else {
            print("[VM] ISO8601 파싱 실패, 백업 방식 시도")
            let backupFormatter = DateFormatter()
            backupFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
            backupFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = backupFormatter.date(from: expirationDate) {
                parsedDate = date
                print("백업 방식으로 날짜 파싱 성공")
            } else {
                print("모든 날짜 파싱 방법 실패")
                onTimerFinished?()
                return
            }
        }
        
        // 남은 시간 계산
        if let parsedDate = parsedDate {
            let timeInterval = parsedDate.timeIntervalSinceNow
            remainingTime = Int(ceil(timeInterval))
        }
        
        print("남은 시간(초): \(remainingTime)")
        
        guard remainingTime > 0 else {
            print("남은 시간이 없음")
            onTimerFinished?()
            return
        }
        
        // 기존 타이머가 있다면 정지
        stopTimer()
        
        // 타이머 시작
        updateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.updateTimer()
        })
        
        // 타이머가 실행 중일 때 앱이 백그라운드로 가는 경우에도 계속 실행되도록
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func updateTimer() {
        if remainingTime <= 0 {
            stopTimer()
            onTimerFinished?()
            return
        }
        
        onTimerUpdate?(timeString)
        remainingTime -= 1
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func requestEmailVerification(email: String) async throws -> RequestEmailCodeResponse {
        let response = try await authRepository.requestEmailVerification(email: email)
        print(response)
        return response
    }
}

// MARK: - API Calls
extension SignUpViewModel {
    
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
        let pattern = #"^(?![0-9]+$)[a-zA-Z0-9_](?:[a-zA-Z0-9_]*(?:\.[a-zA-Z0-9_]+)?){1,19}$"#
        
        if nickname.range(of: pattern, options: .regularExpression) != nil {
            try await authRepository.setNickname(nickname: nickname)
        } else {
            throw NetworkError.notValidNickname
        }
    }
    
    func checkSignUpStatus(email: String) async throws  {
        try await authRepository.checkSignUpStatus(email: email)
    }
}
