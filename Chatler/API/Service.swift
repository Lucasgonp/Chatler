//
//  Service.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

protocol ServiceProtocol {
    func fetchUser(withUid uid: String, completion: @escaping (Result<User, CustomError>) -> Void)
}

struct Service: ServiceProtocol {
    static let shared: ServiceProtocol = Service()
    
    func fetchUser(withUid uid: String, completion: @escaping (Result<User, CustomError>) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(.fetchUser))
            }
            guard let dictionary = snapshot?.data(),
                  let user = User(dictionary: dictionary) else {
                completion(.failure(.fetchUser))
                return
            }
            
            completion(.success(user))
        }
    }
}
