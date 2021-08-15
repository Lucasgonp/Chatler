//
//  ConversationsViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Foundation

protocol ConversationsViewModelInput: AnyObject {
    var output: ConversationsViewModelOutput? { get set }
    
    func loadConversations()
}

class ConversationsViewModel: ConversationsViewModelInput {
    weak var output: ConversationsViewModelOutput?
    
    var service = ConversationsService.shared
    
    private let activityIndicator = ActivityIndicator().spinner
    
    func loadConversations() {
        output?.tableView.backgroundView = activityIndicator
        
        service.fetchConversations { result in
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let conversations):
                self.output?.onLoadConversations(conversations: conversations)
            case .failure(let error):
                self.output?.showError(error.localizedDescription)
            }
        }
    }
}
