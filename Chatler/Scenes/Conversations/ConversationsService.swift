//
//  ConversationsService.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Firebase

protocol ConversationsServiceProtocol {
    func fetchConversations(completion: @escaping ([Conversation]) -> ())
}

struct ConversationsService: ConversationsServiceProtocol {
    static let shared: ConversationsServiceProtocol = ConversationsService()
    
    func fetchConversations(completion: @escaping ([Conversation]) -> ()) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            if snapshot?.count == 0 { completion([]) }
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                Service.shared.fetchUser(withUid: message.chatPartnerId) { result in
                    switch result {
                    case .success(let user):
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                    case .failure(let error):
                        //TODO Error handling
                        completion([])
                    }
                }
            })
        }
        
    }
}
