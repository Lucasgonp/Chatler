//
//  MessageCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit
import SnapKit

class MessageCell: CollectionViewCell {
    
    // MARK: - Properties
    
    weak var output: ChatViewModelOutput?
    
    var message: Message? {
        didSet { configure() }
    }
    
    var bubbleLeftAnchor: ConstraintMakerEditable?
    var bubbleRightAnchor: ConstraintMakerEditable?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = Fonts.defaultLight(size: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        return textView
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewHierarchy() {
        addSubview(profileImageView)
        addSubview(bubbleContainer)
        
        bubbleContainer.addSubview(textView)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(snp.leftMargin)
            $0.bottom.equalTo(snp.bottom)
            $0.height.width.equalTo(32)
        }
        
        bubbleContainer.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(4)
            $0.bottom.equalTo(snp.bottomMargin)
            $0.width.lessThanOrEqualTo(250)
            
            bubbleLeftAnchor = $0.left.equalTo(profileImageView.snp.right).offset(12)
            bubbleRightAnchor = $0.right.equalTo(snp.right).offset(-12)
            
            bubbleLeftAnchor?.constraint.isActive = false
            bubbleRightAnchor?.constraint.isActive = false
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(bubbleContainer.snp.top).offset(4)
            $0.left.equalTo(bubbleContainer.snp.left).offset(4)
            $0.bottom.equalTo(bubbleContainer.snp.bottom).offset(-4)
            $0.right.equalTo(bubbleContainer.snp.right).offset(-4)
        }
        
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}

    // MARK: - Private helpers

private extension MessageCell {
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message, delegate: self)
        
        /// Checking if message is a image or photo
        if let imageUrl = message.image {
            loadImageIfNeeded(photoUrl: imageUrl)
        } else {
            photoView.removeFromSuperview()
            textView.text = message.text
        }
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        
        bubbleLeftAnchor?.constraint.isActive = viewModel.leftAncherActive
        bubbleRightAnchor?.constraint.isActive = viewModel.rightAncherActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    func loadImageIfNeeded(photoUrl: String) {
        guard let url = URL(string: photoUrl) else { return }
        bubbleContainer.addSubview(photoView)
        buildImageConstraint()
        photoView.sd_setImage(with: url) { _,_,_,_ in
            self.layoutIfNeeded()
        }
    }
    
    func buildImageConstraint() {
        photoView.snp.makeConstraints {
            $0.center.equalTo(bubbleContainer.snp.center)
            $0.top.equalTo(bubbleContainer.snp.top).offset(4)
            $0.bottom.equalTo(bubbleContainer.snp.bottom).offset(-4)
            $0.left.equalTo(bubbleContainer.snp.left).offset(4)
            $0.right.equalTo(bubbleContainer.snp.right).offset(-4)
            $0.height.equalTo(250)
        }
    }
}

    // MARK: - Outputs

extension MessageCell: MessageViewModelOutput {
    func dismiss() {
        //
    }
}
