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

protocol RegistrationViewModelDelegate: AnyObject {
    var controller: RegistrationControllerDelegate? { get set }
    
    var profileImage: UIImage? { get set }
    var email: String? { get set }
    var fullName: String? { get set }
    var username: String? { get set }
    var password: String? { get set }
    
    var formIsValid: Bool { get }
    
    var signUpButton: PrimaryButton { get }
    
    func loadSignUpUser()
}

class RegistrationViewModel: RegistrationViewModelDelegate {
    weak var controller: RegistrationControllerDelegate?
    
    var email, fullName, username, password: String?
    var profileImage: UIImage?
    var profileImageUrl: String?
    
    let signUpButton: PrimaryButton
    
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
    
    init(signUpButton: PrimaryButton) {
        self.signUpButton = signUpButton
    }
    
    func loadSignUpUser() {
        guard let _ = unwrapRegistrationForm() else { return }
        signUpButton.loadingIndicator(true)
            
        let group = DispatchGroup()
        
        group.enter()
        self.prepareImage(profileImage: self.profileImage) { result in
            self.handleLoadedImage(result: result)
            group.leave()
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            self.createUser(profileImageUrl: self.profileImageUrl, completion: self.handleCreatedUser(result:))
        }
    }
    
    // MARK: - Handlers
    
    func handleLoadedImage(result: Result<String, Error>) {
        switch result {
        case .success(let profileImageUrl):
            self.profileImageUrl = profileImageUrl
        
        case .failure(let error):
            DispatchQueue.main.async {
                self.signUpButton.loadingIndicator(false)
                self.controller?.showError(error.localizedDescription)
            }
        }
    }
    
    func handleCreatedUser(result: Result<AuthDataResult, Error>) {
        DispatchQueue.main.async {
            self.signUpButton.loadingIndicator(false)
            
            switch result {
            case .success(let result):
                self.controller?.didCreateUser()
            case .failure(let error):
                self.controller?.showError(error.localizedDescription)
            }
        }
    }
    
    func prepareImage(profileImage: UIImage?, completion: @escaping (Result<String, Error>) -> ()) {
        guard let profileImage = profileImage,
              let imageData = profileImage.jpegData(compressionQuality: 0.3) else {
            completion(.failure(CustomError.genericError))
            return
        }
        
        let filename = NSUUID().uuidString
        service.prepareImage(filename: filename, imageData: imageData, completion: completion)
    }
    
    func createUser(profileImageUrl: String?, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        guard var registrationForm = unwrapRegistrationForm(),
              let profileImageUrl = profileImageUrl else {
            completion(.failure(CustomError.genericError))
            return
        }
        
        registrationForm.profileImageUrl = profileImageUrl
        service.signUpNewUser(form: registrationForm, completion: completion)
    }
    
    func unwrapRegistrationForm() -> RegistrationForm? {
        guard let email = email, let password = password,
              let fullname = fullName, let username = username,
              !email.isEmpty, !password.isEmpty,
              !fullname.isEmpty, !username.isEmpty else { return nil }
        
        return RegistrationForm(email: email, fullname: fullname, username: username, password: password, profileImage: profileImage)
    }
}
