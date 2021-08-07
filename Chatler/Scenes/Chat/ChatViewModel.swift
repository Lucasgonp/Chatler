//
//  ChatViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import Foundation
import UIKit

protocol ChatViewModelInput: AnyObject {
    var output: ChatViewModelOutput? { get set }
    
    func loadMessages(from contact: User)
    func uploadMessage(message: String, user: User)
}

class ChatViewModel: ChatViewModelInput {
    weak var output: ChatViewModelOutput?
    
    func loadMessages(from contact: User) {
        output?.loadingIndicator(true)
        
        DispatchQueue.global(qos: .userInitiated).async {
            ChatService.shared.fetchMessages(forUser: contact) { [weak self] messages in
                DispatchQueue.main.async {
                    self?.output?.loadingIndicator(false)
                    self?.output?.fetchMessages(messages: messages)
                }
            }
        }
    }
    
    func uploadMessage(message: String, user: User) {
        ChatService.shared.uploadMessage(message, to: user) { [weak self] error in
            if let error = error {
                self?.output?.showError(error.localizedDescription)
                return
            }
        }
    }
}
