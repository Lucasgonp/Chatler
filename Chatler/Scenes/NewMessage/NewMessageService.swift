//
//  NewMessageService.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Firebase

protocol NewMessageServiceProtocol {
    func fetchUsers(completion: @escaping ([User]) -> Void)
}

struct NewMessageService: NewMessageServiceProtocol {
    static let shared: NewMessageServiceProtocol = NewMessageService()
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data()) }) else { return }
            
            if let i = users.firstIndex(where: {$0.uid == uid}) {
                users.remove(at: i)
            }
            
            completion(users)
        }
    }
}
