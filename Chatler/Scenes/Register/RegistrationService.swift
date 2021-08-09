//
//  RegistrationService.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct RegistrationService {
    static let shared = RegistrationService()
    
    func prepareImage(filename: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let ref = Storage.storage().reference(withPath: "profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta,error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            handlePreparedImage(ref: ref, completion: completion)
        }
    }
    
    func signUpNewUser(form: RegistrationForm, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().createUser(withEmail: form.email, password: form.password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else {
                completion(.failure(CustomError.genericError))
                return
            }
            
            var data = form.dictionary
            data["uid"] = uid
            
            COLLECTION_USERS.document(uid).setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                } else if let result = result {
                    print("Debug: User created!!")
                    completion(.success(result))
                }
            }
        }
    }
}

    // MARK: - Extensions

private extension RegistrationService {
    
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
    
    func uploadUserData(uid: String, form: RegistrationForm, completion: ((Error?) -> Void)?) {
        
    }
}
