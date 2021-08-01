//
//  NewMessageViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import Foundation

protocol NewMessageViewModelDelegate {
    var controller: NewMessageControllerDelegate? { get set }
}

class NewMessageViewModel: NewMessageViewModelDelegate {
    weak var controller: NewMessageControllerDelegate?
    
    private var users = [User]()
    
    private lazy var presenter: NewMessagePresenterDelegate = {
        let presenter = NewMessagePresenter()
        presenter.controller = controller
        return presenter
    }()
    
    func loadUsers() {
        controller?.showLoading()
        Service.fetchUsers { [weak self] users in
            self?.controller?.hideLoading()
            
            self?.users = users
            self?.controller?.users = users
            self?.controller?.reloadTableView()
        }
    }
    
}
