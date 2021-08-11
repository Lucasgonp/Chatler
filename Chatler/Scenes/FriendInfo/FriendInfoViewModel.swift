//
//  FriendInfoViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 09/08/21.
//

import Foundation
import FirebaseAuth

protocol FriendInfoViewModelInput: AnyObject {
    var output: FriendInfoViewModelOutput? { get set }
    func loadUser()
}

protocol FriendInfoViewModelOutput: BaseOutputProtocol {
    func didLoadUser(user: User)
}

class FriendInfoViewModel: FriendInfoViewModelInput {
    weak var output: FriendInfoViewModelOutput?
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUser(withUid: uid) { [weak self] result in
            self?.handleLoadUser(result)
        }
    }
}

private extension FriendInfoViewModel {
    func handleLoadUser(_ result: Result<User, Error>) {
        switch result {
        case .success(let user):
            self.output?.didLoadUser(user: user)
        case .failure(let error):
            DispatchQueue.main.async {
                self.output?.hideLoading()
                self.output?.showError(error.localizedDescription)
            }
        }
    }
}
