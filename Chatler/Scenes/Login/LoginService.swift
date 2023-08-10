//
//  LoginService.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

import FirebaseAuth

struct LoginService {
    static let shared: LoginService = LoginService()
    
    func logUserIn(email: String, password: String, completion: ((AuthDataResult?, (any Error)?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func logUserOut() {
        
    }
}
