//
//  ConversationsViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Foundation
import FirebaseAuth

protocol ConversationsViewModelInput: AnyObject {
    var output: ConversationsViewModelOutput? { get set }
    var service: ConversationsServiceProtocol { get }
    var conversations: [Conversation] { get set }
    var conversationsDictionary: [String: Conversation] { get set }
    
    func authenticate()
    func logout()
    func loadConversations()
    func selectConversation(_ indexPath: Int)
}

class ConversationsViewModel: ConversationsViewModelInput {
    weak var output: ConversationsViewModelOutput?
    var service = ConversationsService.shared
    
    var conversations = [Conversation]()
    var conversationsDictionary = [String: Conversation]()
    
    private let activityIndicator = ActivityIndicator().spinner
    
    func authenticate() {
        if let _ = Auth.auth().currentUser?.uid {
            output?.onAuthenticate()
        } else {
            output?.presentLoginScreen()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            conversations = []
            conversationsDictionary = [:]
            output?.reloadTableView()
            output?.presentLoginScreen()
        } catch {
            output?.showError(error.localizedDescription)
        }
    }
    
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
    
    func selectConversation(_ indexPath: Int) {
        let user = conversations[indexPath].user
        output?.onOpenChat(with: user)
    }
}
