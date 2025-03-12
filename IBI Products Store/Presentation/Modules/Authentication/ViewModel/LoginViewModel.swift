//
//  LoginViewModel.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import Foundation

final class LoginViewModel {
    // MARK: Properties
    private let validUsername = "admin"
    private let validPassword = "testPassword2025"
    
    // MARK: - accessible method to validate creds
    func validateCredentials(username: String, password: String) -> Bool {
        return username == validUsername && password == validPassword
    }
}
