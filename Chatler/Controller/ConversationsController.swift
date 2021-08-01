//
//  ConversationsController.swift
//  Chatler
//
//  Created by Lucas Pereira on 26/07/21.
//

import UIKit
import SnapKit
import FirebaseAuth

private let reuseIdentifier = "ConversationCell"

class ConversationsController: ViewController {
    
    // MARK: - Proprieties
    private lazy var profileButton: UIBarButtonItem = {
        let img = Images.Login.profile
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(showProfile))
        
        return item
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        
        return button
    }()
    
    // MARK:- Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: Strings.Conversations.title, prefersLargeTitles: true)
        navigationItem.leftBarButtonItem = profileButton
        configureTableView()
    }
    
    override func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(newMessageButton)
    }
    
    override func setupConstraints() {
        // TODO
        newMessageButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp_bottomMargin).inset(16)
            $0.right.equalTo(view.snp_rightMargin).inset(24)
            $0.height.width.equalTo(56)
        }
    }
    
    override func configureViews() {
        //
    }
    
    // MARK: - API
    
    func authenticateUser() {
        // Is user logged in?
        if let uid = Auth.auth().currentUser?.uid {
            print("DEBUG: User ID is \(uid)")
        } else {
            print("DEBUG: User is NOT logged in)")
            presentLoginScreen()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Signed out!")
            
            presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    
    @objc func showProfile() {
      logout()
    }
    
    // MARK: - Helpers
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let viewModel = LoginViewModel()
            let controller = LoginController(viewModel: viewModel)
            viewModel.controller = controller
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureTableView() {
        tableView.frame = view.frame
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func showNewMessage() {
        let viewModel = NewMessageViewModel()
        let controller = NewMessageController(viewModel: viewModel)
        viewModel.controller = controller
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "José"
        return cell
    }
    
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
