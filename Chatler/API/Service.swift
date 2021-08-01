//
//  Service.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import Firebase

struct Service {
    static func fetchUsers(completion: @escaping ([User]) -> ()) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
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

extension Encodable {
  /// Returns a JSON dictionary, with choice of minimal information
  func getDictionary() -> [String: Any]? {
    let encoder = JSONEncoder()

    guard let data = try? encoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
    }
  }
}

extension Decodable {
  /// Initialize from JSON Dictionary. Return nil on failure
  init?(dictionary value: [String:Any]){

    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }

    guard let newValue = try? JSONDecoder().decode(Self.self, from: jsonData) else { return nil }
    self = newValue
  }
}
