//
//  NewMessagePresenter.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

protocol NewMessagePresenterDelegate {
    var controller: NewMessageDelegateOutput? { get set }
    
    func dismiss()
}

final class NewMessagePresenter: NewMessagePresenterDelegate {
    internal var controller: NewMessageDelegateOutput?
    
    func dismiss() {
        controller?.dismiss()
    }
    
}

