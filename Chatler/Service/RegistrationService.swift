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
    
    func prepareImage(filename: String, imageData: Data, completion: @escaping (Result<String, LoginError>) -> ()) {
        let ref = Storage.storage().reference(withPath: "profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { (meta,error) in
            if let error = error {
                print("Debug: Error while upload image: \(error.localizedDescription)!!")
                completion(.failure(.uploadError))
                return
            }
            
            handlePreparedImage(ref: ref, completion: completion)
        }
    }
    
    func signUpNewUser(form: RegistrationForm, completion: @escaping (LoginError?) -> ()) {
        Auth.auth().createUser(withEmail: form.email, password: form.password) { result, error in
            if let error = error {
                completion(.creatingUserError)
                print("Debug: Error while creating user: \(error.localizedDescription)!!")
                return
            }
            guard let uid = result?.user.uid else {
                completion(.getUidError)
                return
            }
            
            uploadUserData(uid: uid, form: form, completion: completion)
        }
    }
}

    // MARK: - Extensions

private extension RegistrationService {
    
    func handlePreparedImage(ref: StorageReference, completion: @escaping (Result<String, LoginError>) -> ()) {
        ref.downloadURL { url, error in
            guard let profileImageUrl = url?.absoluteString else {
                completion(.failure(.downloadError))
                return
            }
            
            completion(.success(profileImageUrl))
        }
    }
    
    func uploadUserData(uid: String, form: RegistrationForm, completion: ((LoginError?) -> Void)?) {
        
        let data = ["email": form.email,
                    "fullname": form.fullName,
                    "profileImageUrl": form.profileImageUrl ?? Images.Register.defaultProfileImageUrl,
                    "username": form.username,
                    "uid": uid] as [String: Any]
        
        Firestore.firestore().collection("users").document(uid).setData(data) { error in
            if let error = error {
                
                print("Debug: Error while upload user data: \(error.localizedDescription)!!")
                completion!(.uploadUserDataError)
            } else {
                
                print("Debug: User created!!")
                completion!(nil)
            }
        }
    }
}
