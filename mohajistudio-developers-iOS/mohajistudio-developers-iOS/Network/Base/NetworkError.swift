//
//  NetworkError.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case alreadyRegistered // R0001
    case tooManyRequestCode // EV004
    case failedToSendEmail // EV0001
    
    case notValidCode // EV0002
    case tooManyAttempts // EV0003
    
    case unknownUser // U0001
    case passwordAlreadyExists // R0002
    
    case nicknameAlreadyExists // R0003
    case notValidNickname // C0001
    
    case passwordNotSet // R0005
    case profileNameNotSet // R0006
    
    case serverError
    case networkError
    case unknown(String)
    
    var errorMessage: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .alreadyRegistered:
            return "이미 존재하는 유저입니다."
        case .tooManyRequestCode:
            return "이메일 인증 요청은 하루 최대 3회까지 요청할 수 있습니다.\n24시간 뒤에 다시 시도해주세요."
        case .failedToSendEmail:
            return "이메일 전송에 실패했습니다."
        case .notValidCode:
            return "유효하지 않은 인증 코드입니다."
        case .tooManyAttempts:
            return "이메일 인증 횟수 초과"
        case .unknownUser:
            return "알 수 없는 유저입니다."
        case .passwordAlreadyExists:
            return "비밀번호를 이미 설정하셨습니다."
        case .notValidNickname:
            return "유효하지 않은 닉네임입니다."
        case .nicknameAlreadyExists:
            return "이미 설정된 닉네임입니다."
        case .passwordNotSet:
            return "비밀번호를 아직 설정하지 않으셨습니다."
        case .profileNameNotSet:
            return "프로필 이름을 아직 설정하지 않으셨습니다."
        case .serverError:
            return "Server error occured"
        case .networkError:
            return "Network error occured"
        case .unknown(let message):
            return message
        }
    }
}

// 코드 발급 EV004: 인증 메일 요청 횟수 초과, EV0001: 이메일 전송 실패, R0001: 이미 존재하는 유저
// 코드 인증 EV0002: 유효하지 않은 코드, EV0003: 이메일 인증 횟수 초과, R0001: 이미 존재하는 유저
// 비번 설정 U0001: 알 수 없는 유저, R0002: 이미 설정된 비밀번호, R0001: 이미 존재하는 유저
// 닉네임 설정 U0001: 알 수 없는 유저, R0003: 이미 설정된 닉네임, R0001: 이미 존재하는 유저
// 로그인 U0001: 알 수 없는 유저, R0005: 설정되지 않은 비밀번호, R0006: 설정되지 않은 닉네임

