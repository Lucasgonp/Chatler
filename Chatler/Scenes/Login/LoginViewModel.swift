//
//  LoginViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import Foundation

protocol LoginViewModelInput {
    var controller: LoginViewModelOutput? { get set }
    var formIsValid: Bool { get }
    
    func doLogin()
}

class LoginViewModel: LoginViewModelInput {
    var controller: LoginViewModelOutput?
    var email: String?
    var password: String?
    
    let service = LoginService.shared
    
    var formIsValid: Bool {
        guard let email = email, let password = password,
              !email.isEmpty, !password.isEmpty else { return false }
        
        return true
    }
    
    func doLogin() {
        guard let email = email,
              let password = password else { return }
        
        service.logUserIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.controller?.handleError(error: error)
            } else if let result = result {
                self.controller?.dismissView()
            }
        }
    }
}
