//
//  NewMessageViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import Foundation

protocol NewMessageViewModelDelegate: AnyObject {
    var controller: NewMessageDelegateOutput? { get set }
    
    func loadUsers()
}

class NewMessageViewModel: NewMessageViewModelDelegate {
    weak var controller: NewMessageDelegateOutput?
    
    private var users = [User]()
    
    private lazy var presenter: NewMessagePresenterDelegate = {
        let presenter = NewMessagePresenter()
        presenter.controller = controller
        return presenter
    }()
    
    func loadUsers() {
        controller?.showLoading()
        NewMessageService.shared.fetchUsers { [weak self] users in
            self?.controller?.hideLoading()
            
            self?.users = users
            self?.controller?.users = users
            self?.controller?.reloadTableView()
        }
    }
    
}
