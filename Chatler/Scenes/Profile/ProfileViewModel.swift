//
//  ProfileViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 04/08/21.
//

import Foundation
import FirebaseAuth

protocol ProfileViewModelInput: AnyObject {
    var output: ProfileViewModelOutput? { get set }
    func loadUser()
}

protocol ProfileViewModelOutput: BaseOutputProtocol {
    func didLoadUser(user: User)
}

class ProfileViewModel: ProfileViewModelInput {
    weak var output: ProfileViewModelOutput?
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUser(withUid: uid) { [weak self] result in
            self?.handleLoadUser(result)
        }
    }
}

private extension ProfileViewModel {
    func handleLoadUser(_ result: Result<User, Error>) {
        switch result {
        case .success(let user):
            self.output?.didLoadUser(user: user)
        case .failure(let error):
            self.output?.showError(error.localizedDescription)
        }
    }
}
