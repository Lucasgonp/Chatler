//
//  ChatController.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit
import SnapKit

private let reuseIdentifier = "MessageCell"

protocol ChatViewModelOutput: BaseOutputProtocol {
    func fetchMessages(messages: [Message])
    
    func loadingIndicator(_ show: Bool)
}

class ChatController: CollectionViewController {
    
    //MARK: - Properties
    private let user: User
    private var messages: [Message] = [Message]()
    var fromCurrentUser: Bool = false
    
    lazy var autoScrollAnimated: Bool = false
    
    private lazy var viewModel: ChatViewModelInput = ChatViewModel()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let customInputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        
        customInputView.delegate = self
        return customInputView
    }()
    
    
    //MARK: - Lifecicle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
        hideKeyboardWhenTappedAround()
    }
    
    
    override func buildViewHierarchy() {
        
    }
    
    override func setupConstraints() {
        
    }
    
    override func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.fullname, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - API
    func loadMessages() {
        viewModel.loadMessages(from: user)
    }
    
    //MARK: - Helpers
    
    
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {
            return UICollectionViewCell()
        }
        cell.output = self
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: width, height: estimatedSize.height)
    }
}

    // MARK: - Outputs
extension ChatController: ChatViewModelOutput {
    func loadingIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func fetchMessages(messages: [Message]) {
        self.messages = messages
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, messages.count - 1], at: .bottom, animated: true)
        }
    }
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        inputView.clearMessageText()
        viewModel.uploadMessage(message: message, user: user)
    }
}
