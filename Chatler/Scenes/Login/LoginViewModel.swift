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

protocol LoginViewModelOutput: BaseOutputProtocol {
    func checkFormStatus()
    func dismissView()
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
        
        controller?.showLoading(text: "Login in...")
        service.logUserIn(email: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Erro ao logar: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.controller?.hideLoading()
                self.controller?.dismissView()
            }
        }
    }
}
