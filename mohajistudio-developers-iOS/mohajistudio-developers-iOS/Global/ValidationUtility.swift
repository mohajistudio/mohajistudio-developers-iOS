//
//  ValidationUtility.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/26/24.
//

import Foundation

class ValidationUtility {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }

    // 8~15자 사이, 대소문자, 숫자, 특수문자(.!@#$%) 포함
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    static func isValidVerificationCode(_ code: String) -> Bool {
        return code.count == 6
    }
    
}
