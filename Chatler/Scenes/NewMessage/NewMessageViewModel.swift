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
    
    private lazy var presenter: NewMessagePresenterDelegate = {
        let presenter = NewMessagePresenter()
        presenter.controller = controller
        return presenter
    }()
    
    func loadUsers() {
        controller?.loadingIndicator(true)
        NewMessageService.shared.fetchUsers { [weak self] result in
            self?.controller?.loadingIndicator(false)
            
            switch result {
            case .success(let users):
                self?.controller?.reloadTableView(withUsers: users)
            case . failure(let error):
                self?.controller?.showError(error.localizedDescription)
            }
        }
    }
    
}
