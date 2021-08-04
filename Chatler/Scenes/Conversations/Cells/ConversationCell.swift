//
//  ConversationCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import UIKit

class ConversationCell: TableViewCell {
    
    //MARK: - Properties
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.lightGray
        imageView.layer.cornerRadius = 50 / 2
        return imageView
    }()
    
    let timestampLabel: UILabel = {
       let label = UILabel()
        label.font = Fonts.defaultLight(size: 12)
        label.textColor = .darkGray
        label.text = "14h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
         label.font = Fonts.defaultBold(size: 14)
         return label
     }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
         label.font = Fonts.defaultLight(size: 14)
         return label
     }()
    
    private lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        //
    }
    
    override func buildViewHierarchy() {
        addSubview(profileImageView)
        addSubview(timestampLabel)
        addSubview(stack)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(12)
            $0.width.height.equalTo(50)
            $0.centerY.equalTo(snp.centerY)
        }
        
        stack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.right.equalTo(snp.right).offset(16)
        }
        
        timestampLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(20)
            $0.right.equalTo(snp.right).offset(-12)
        }
    }
    
    //MARK: - Properties
    func configureStackView() {
        
    }
    
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationCellViewModel(conversation: conversation)
        
        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
