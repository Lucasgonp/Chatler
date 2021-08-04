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

protocol ConversationsViewModelOutput: BaseOutputProtocol {
    func onLoadConversations(conversations: [Conversation])
}

class ConversationsViewModel: ConversationsViewModelInput {
    weak var output: ConversationsViewModelOutput?
    
    let service = ConversationsService.shared
    
    func loadConversations() {
        service.fetchConversations { conversations in
            self.output?.onLoadConversations(conversations: conversations)
        }
    }
}
