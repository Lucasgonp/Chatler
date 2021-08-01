//
//  UserCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPurple
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 64 / 2
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "spiderman"
        label.font = Fonts.defaultBold(size: 14)
        return label
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.text = "Peter Parker"
        label.font = Fonts.defaultLight(size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        return stack
    }()
    
    // MARK: - Lifecicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(profileImageView)
        addSubview(stack)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(contentView.snp_leftMargin).offset(12)
            $0.height.width.equalTo(64)
        }
        
        stack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
    }

        // MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
        
    }

}
