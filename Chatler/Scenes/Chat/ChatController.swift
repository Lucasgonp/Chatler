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
    
    private lazy var viewModel: ChatViewModelInput = ChatViewModel(user: user)
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImage, usernameLabel])
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        imageView.addSubview(activityIndicator)
        imageView.layer.cornerRadius = 32 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var usernameLabel: UILabel {
        let label = UILabel()
        label.text = user.fullname
        return label
    }
    
    private var imageToSend: UIImage? {
        didSet {
            sendImage()
        }
    }
    
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openFriendController))
        stack.addGestureRecognizer(gesture)
        navigationItem.titleView = stack
    }
    
    override func setupConstraints() {
        userImage.snp.makeConstraints {
            $0.height.width.equalTo(32)
        }
    }
    
    @objc func openFriendController() {
        let controller = FriendInfoController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func configureUI() {
        collectionView.backgroundColor = .white
        
        let backImg = UIImageView(image: Images.Chat.background)
        backImg.contentMode = .scaleAspectFill
        collectionView.backgroundView = backImg
        
        configureNavigationBar(withTitle: user.fullname, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        userImage.sd_setImage(with: url) { image, error, _, _ in
            self.activityIndicator.stopAnimating()
        }
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - API
    func loadMessages() {
        viewModel.loadMessages()
    }
    
}

    //MARK: - Private Helpers

private extension ChatController {
    func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true)
    }
    
    func sendImage() {
        guard let image = imageToSend else { return }
        viewModel.sendImage(image: image)
    }
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

    // MARK: - UIImagePickerControllerDelegate

extension ChatController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        imageToSend = image
        
        dismiss(animated: true)
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
    func showPlusActions() {
        let sendPhoto = UIAlertAction(title: Strings.Chat.sendPhoto, style: .default) { _ in
            self.dismiss(animated: true) {
                self.handleSelectPhoto()
            }
        }

        showInteractiveModal(actions: [sendPhoto])
    }
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        inputView.clearMessageText()
        viewModel.uploadMessage(message: message)
    }
}
