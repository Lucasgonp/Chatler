//
//  LoginViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import Foundation

protocol LoginViewModelDelegate {
    var controller: LoginControllerDelegate? { get set }
    var formIsValid: Bool { get }
    
    func doLogin()
}

class LoginViewModel: LoginViewModelDelegate {
    var controller: LoginControllerDelegate?
    var email: String?
    var password: String?
    
    let service = LoginService.shared
    private lazy var presenter: LoginPresenter = {
        let presenter = LoginPresenter()
        presenter.controller = controller
        return presenter
    }()
    
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
            
            self.presenter.dismiss()
        }
    }
}
