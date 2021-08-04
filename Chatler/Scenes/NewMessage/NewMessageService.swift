//
//  NewMessageService.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Firebase

protocol NewMessageServiceProtocol {
    func fetchUsers(completion: @escaping ([User]) -> ())
}

struct NewMessageService: NewMessageServiceProtocol {
    static let shared: NewMessageServiceProtocol = NewMessageService()
    
    func fetchUsers(completion: @escaping ([User]) -> ()) {
        var users = [User]()
        COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()

                if let user = User(dictionary: dictionary) {
                    users.append(user)
                    completion(users)
                }
            })
        }
    }
}
