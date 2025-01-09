//
//  LoginViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/16/24.
//

import Foundation

final class LoginViewModel {
    
    private(set) var email: String = ""
    private(set) var password: String = ""
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    
    
    // MARK: - Business Logic
    
    
    func login() async throws {
//        guard !email.isEmpty else {
////            throw LoginError.emptyEmail
//            print("email is nil")
//        }
//        
        print("email: \(email), password: \(password)")
    }
    
}
