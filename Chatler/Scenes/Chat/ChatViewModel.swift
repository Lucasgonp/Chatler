//
//  ChatViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import Foundation
import UIKit

protocol ChatViewModelInput: AnyObject {
    var output: ChatViewModelOutput? { get set }
    
    func loadMessages()
    func uploadMessage(message: String)
    func sendImage(image: UIImage?)
}

class ChatViewModel: ChatViewModelInput {
    
    // MARK: - Proprieties
    
    weak var output: ChatViewModelOutput?
    private var service: ChatServiceProtocol {
        let service = ChatService.shared
        return service
    }
    
    private let user: User
    
    var imageToSendUrl: String? {
        didSet {
            sendToSnapshot()
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Helpers
    
    func loadMessages() {
        output?.loadingIndicator(true)
        
        self.service.fetchMessages(forUser: self.user) { [weak self] messages in
            DispatchQueue.main.async {
                self?.output?.loadingIndicator(false)
                self?.output?.fetchMessages(messages: messages)
            }
        }
    }
    
    func uploadMessage(message: String) {
        service.upload(message, nil, to: user) { [weak self] error in
            if let error = error {
                self?.output?.showError(error.localizedDescription)
                return
            }
        }
    }
    
    func uploadImage(imageUrl: String) {
        ChatService.shared.upload("🌆 image", imageUrl, to: user) { [weak self] error in
            if let error = error {
                self?.output?.showError(error.localizedDescription)
                return
            }
        }
    }
    
    func sendImage(image: UIImage?) {
        prepareImage(profileImage: image, completion: handleLoadedImage(result:))
    }
}

    // MARK: - Private handlers

private extension ChatViewModel {
    func handleLoadedImage(result: Result<String, Error>) {
        switch result {
        case .success(let imageUrl):
            self.imageToSendUrl = imageUrl
            return
        case .failure(let error):
            DispatchQueue.main.async {
                self.output?.showError(error.localizedDescription)
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
    
    func sendToSnapshot() {
        guard let imageUrl = imageToSendUrl else { return }
        uploadImage(imageUrl: imageUrl)
    }
}
