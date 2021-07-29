//
//  RegistrationViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var fullName: String?
    var username: String?
    var password: String?
    
    var formIsValid: Bool {
        guard let email = email, let password = password,
              let fullName = fullName, let username = username,
              !email.isEmpty, !password.isEmpty,
              !fullName.isEmpty, !username.isEmpty else { return false }

        return true
    }
}
