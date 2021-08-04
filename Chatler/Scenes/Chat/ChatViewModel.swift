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

protocol ChatViewModelOutput: BaseOutputProtocol {
    func fetchMessages(messages: [Message])
}

class ChatViewModel: ChatViewModelInput {
    weak var output: ChatViewModelOutput?
    
    func loadMessages(from contact: User) {
        output?.showLoading(text: "Loading messages...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            ChatService.shared.fetchMessages(forUser: contact) { [weak self] messages in
                DispatchQueue.main.async {
                    self?.output?.hideLoading()
                    self?.output?.fetchMessages(messages: messages)
                }
            }
        }
    }
    
    func uploadMessage(message: String, user: User) {
        ChatService.shared.uploadMessage(message, to: user) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}
