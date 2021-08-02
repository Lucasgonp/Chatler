//
//  ChatViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import Foundation
import UIKit

protocol ChatViewModelInput: AnyObject {
    
}

protocol ChatViewModelOutput: AnyObject {
    
}

class ChatViewModel: ChatViewModelInput {
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
    
    init(message: Message) {
        self.message = message
    }
}
