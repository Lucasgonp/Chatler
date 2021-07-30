//
//  LoginPresenter.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

protocol LoginPresenterDelegate {
    var controller: LoginControllerDelegate? { get set }
    
    func dismiss()
}

final class LoginPresenter: LoginPresenterDelegate {
    var controller: LoginControllerDelegate?
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func dismiss() {
        controller?.dismiss()
    }
}
