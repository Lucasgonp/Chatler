//
//  Service.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import Foundation

protocol ServiceProtocol {
    func fetchUser(withUid uid: String, completion: @escaping (Result<User, Error>) -> Void)
    //func prepareImage()
}

struct Service: ServiceProtocol {
    static let shared: ServiceProtocol = Service()
    
    func fetchUser(withUid uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let dictionary = snapshot?.data() else {
                completion(.failure(CustomError.genericError))
                return
            }
            
            let user = User(dictionary: dictionary)
            completion(.success(user))
        }
    }
}
