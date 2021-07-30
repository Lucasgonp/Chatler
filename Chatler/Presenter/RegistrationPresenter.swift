//
//  RegistrationPresenter.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

protocol RegisterPresenterDelegate {
    var controller: RegistrationControllerDelegate? { get set }
    
    func dismiss()
}

final class RegistrationPresenter: RegisterPresenterDelegate {
    internal var controller: RegistrationControllerDelegate?
    
    func dismiss() {
        controller?.dismiss()
    }
    
}
