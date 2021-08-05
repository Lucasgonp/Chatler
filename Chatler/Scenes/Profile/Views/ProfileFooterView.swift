//
//  ProfileFooterView.swift
//  Chatler
//
//  Created by Lucas Pereira on 04/08/21.
//

import UIKit

protocol ProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class ProfileFooterView: View {
    
    // MARK: - Properties
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.Profile.logout, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.defaultBold(size: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewHierarchy() {
        addSubview(logoutButton)
    }
    
    override func setupConstraints() {
        logoutButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(32)
            $0.right.equalTo(snp.right).offset(-32)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }

    // MARK: - API

    // MARK: - Helpers

}
