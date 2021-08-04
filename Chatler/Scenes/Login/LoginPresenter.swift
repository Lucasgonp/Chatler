//
//  LoginPresenter.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

protocol LoginPresenterDelegate: BaseOutputProtocol {
    var controller: LoginControllerDelegate? { get set }
    
    func dismiss()
}

final class LoginPresenter: LoginPresenterDelegate {
    func showLoading(text: String) {}
    
    func hideLoading(completion: @escaping () -> ()) {}
    
    var controller: LoginControllerDelegate?
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func dismiss() {
        controller?.dismiss()
    }
}
