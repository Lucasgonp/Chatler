//
//  Message.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import Firebase

struct Message {
    let text: String
    let image: String?
    let toId: String
    let fromId: String
    let timestamp: Timestamp
    var user: User?
    
    let isFromCurentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurentUser ? toId : fromId
    }
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.image = dictionary["photoUrl"] as? String
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurentUser = fromId == Auth.auth().currentUser?.uid
    }
}
