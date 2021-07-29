//
//  LoginViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        guard let email = email, let password = password,
              !email.isEmpty, !password.isEmpty else { return false }
        
        return true
    }
}
