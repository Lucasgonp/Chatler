//
//  ChatService.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import Firebase

protocol ChatServiceProtocol {
    func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> ())
    func upload(_ message: String,_ imageUrl: String?, to user: User, completion: ((Error?) -> ())?)
    func prepareImage(filename: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ())
}

struct ChatService: ChatServiceProtocol {
    static let shared: ChatServiceProtocol = ChatService()
    
    func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> ()) {
        var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            if snapshot?.documentChanges.count == 0 {
                completion([])
                return
            }
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                }
            })
            completion(messages)
        }
    }
    
    func upload(_ message: String,_ imageUrl: String? = nil, to user: User, completion: ((Error?) -> ())?) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion?(CustomError.genericError)
            return
        }
        
        let data = ["text": message,
                    "photoUrl": imageUrl as Any,
                    "fromId": currentUid,
                    "toId": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
    
    func prepareImage(filename: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let ref = Storage.storage().reference(withPath: "chat-images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta,error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            handlePreparedImage(ref: ref, completion: completion)
        }
    }
}

private extension ChatService {
    func handlePreparedImage(ref: StorageReference, completion: @escaping (Result<String, Error>) -> ()) {
        ref.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let profileImageUrl = url?.absoluteString else {
                completion(.failure(CustomError.genericError))
                return
            }
            
            completion(.success(profileImageUrl))
        }
    }
}
