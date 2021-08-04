//
//  MessageViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import UIKit

protocol MessageViewModelInput: AnyObject {
    var output: MessageViewModelOutput { get }
}

protocol MessageViewModelOutput: BaseOutputProtocol {}

class MessageViewModel: MessageViewModelInput {
    internal let output: MessageViewModelOutput
    
    private let message: Message
    
    var messageTextColor: UIColor {
        return message.isFromCurentUser ? Colors.mainBlack : Colors.secundaryColor
    }
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurentUser ? Colors.lightGray : Colors.mainColor
    }
    
    var rightAncherActive: Bool {
        return message.isFromCurentUser
    }
    
    var leftAncherActive: Bool {
        return !message.isFromCurentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurentUser
    }
    
    var profileImageUrl: URL? {
        guard let imageUrl = message.user?.profileImageUrl else { return nil }
        return URL(string: imageUrl)
    }
    
    init(message: Message, delegate: MessageViewModelOutput) {
        self.message = message
        self.output = delegate
    }
}
