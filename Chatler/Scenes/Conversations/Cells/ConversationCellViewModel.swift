//
//  ConversationCellViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Foundation

struct ConversationCellViewModel {
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
