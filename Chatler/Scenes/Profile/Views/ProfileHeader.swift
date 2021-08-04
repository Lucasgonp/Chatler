//
//  ProfileHeader.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import UIKit

class ProfileHeader: View {
    // MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    var user: User? {
        didSet { populateUserData() }
    }
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.Common.xMark, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = Colors.mainWhite
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 200 / 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 4.0
        imageView.layer.borderColor = Colors.mainWhite.cgColor
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.defaultBold(size: 20)
        label.textColor = Colors.mainBlack
        label.textAlignment = .center
        label.text = "Jorge Castro"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.defaultLight(size: 16)
        label.textColor = Colors.mainBlack
        label.textAlignment = .center
        label.text = "JorgeCastro"
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewHierarchy() {
        addSubview(dismissButton)
        addSubview(profileImageView)
        addSubview(stack)
    }
    
    override func setupConstraints() {
        dismissButton.imageView?.snp.makeConstraints {
            $0.height.width.equalTo(22)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(44)
            $0.left.equalTo(snp.left).offset(12)
            $0.height.width.equalTo(48)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.height.width.equalTo(200)
            $0.top.equalTo(snp.top).offset(96)
        }
        
        stack.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
        }
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.dismissController()
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    private func populateUserData() {
        guard let user = user else { return }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
}

// SuperMARK
// MARK: - Properties

// MARK: - Lifecycle

// MARK: - Selectors

// MARK: - API

// MARK: - Helpers
