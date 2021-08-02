//
//  RegistrationViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

protocol RegistrationViewModelDelegate {
    var controller: RegistrationControllerDelegate? { get set }
    var formIsValid: Bool { get }
}

class RegistrationViewModel: RegistrationViewModelDelegate {
    weak var controller: RegistrationControllerDelegate?
    
    var email, fullName, username, password: String?
    var profileImage: UIImage?
    var profileImageUrl: String?
    
    private let service = RegistrationService.shared
    private lazy var presenter: RegisterPresenterDelegate = {
        let presenter = RegistrationPresenter()
        presenter.controller = controller
        return presenter
    }()
    
    var formIsValid: Bool {
        guard let _ = unwrapRegistrationForm(),
              let _ = profileImage else { return false }

        return true
    }
    
    func loadSignUpUser() {
        guard let _ = unwrapRegistrationForm() else { return }
        let group = DispatchGroup()
        
        controller?.showLoading(text: "Loggin in...")
        
        group.enter()
        prepareImage(profileImage: profileImage) { result in
            self.handleLoadedImage(result: result)
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.createUser(profileImageUrl: self.profileImageUrl) { error in
                DispatchQueue.main.async {
                    self.handleCreatedUser(error: error)
                }
            }
        }
    }
    
    func handleLoadedImage(result: Result<String, LoginError>) {
        switch result {
        case .success(let profileImageUrl):
            self.profileImageUrl = profileImageUrl
        
        case .failure(let error):
            controller?.hideLoading()
            print(error.errorDescription)
        }
    }
    
    func handleCreatedUser(error: LoginError?) {
        if let error = error {
            controller?.hideLoading()
            print(error.errorDescription)
            return
        }
        
        controller?.dismiss()
    }
    
    func prepareImage(profileImage: UIImage?, completion: @escaping (Result<String, LoginError>) -> ()) {
        guard let profileImage = profileImage else {
            completion(.failure(.imageIsNil))
            return
        }
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {
            completion(.failure(.imageCantCompress))
            return
        }
        
        let filename = NSUUID().uuidString
        service.prepareImage(filename: filename, imageData: imageData, completion: completion)
    }
    
    func createUser(profileImageUrl: String?, completion: @escaping (LoginError?) -> ()) {
        guard var registrationForm = unwrapRegistrationForm(),
              let profileImageUrl = profileImageUrl else {
            completion(.missingFields)
            return
        }
        
        registrationForm.profileImageUrl = profileImageUrl
        
        service.signUpNewUser(form: registrationForm) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func unwrapRegistrationForm() -> RegistrationForm? {
        guard let email = email, let password = password,
              let fullName = fullName, let username = username,
              !email.isEmpty, !password.isEmpty,
              !fullName.isEmpty, !username.isEmpty else { return nil }
        
        return RegistrationForm(email: email, fullName: fullName, username: username, password: password, profileImage: profileImage)
    }
}
