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

protocol ConversationsViewModelOutput: BaseOutputProtocol {
    var tableView: UITableView { get set }
    
    func onLoadConversations(conversations: [Conversation])
}

class ConversationsController: ViewController {
    
    // MARK: - Proprieties
    private let viewModel: ConversationsViewModelInput = ConversationsViewModel()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private lazy var profileButton: UIBarButtonItem = {
        let img = Images.Login.profile
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(showProfile))
        
        return item
    }()
    
    internal var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
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
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
        self.viewModel.output?.tableView = tableView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        authenticateUser()
        loadConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        
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
    
    // MARK: - Selectors
    
    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - Helpers
    
    func loadConversations() {
        viewModel.loadConversations()
    }
    
    func presentLoginScreen() {
            let controller = LoginController()
            controller.delegate = self
        
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
    }
    
    func configureTableView() {
        tableView.frame = view.frame
        
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
}

    // MARK: - UITableViewDelegate
extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
}

    // MARK: - Outputs
extension ConversationsController: ConversationsViewModelOutput {
    
    func onLoadConversations(conversations: [Conversation]) {
        conversations.forEach { conversation in
            let message = conversation.message
            conversationsDictionary[message.chatPartnerId] = conversation
            
        }
        
        self.conversations = Array(conversationsDictionary.values)
        self.tableView.reloadData()
    }
}

    // MARK: - Delegates

extension ConversationsController: NewMessageDelegate {
    func controller(_ controller: TableViewController, wantsToStartChatWith user: User) {
        dismiss(animated: true) {
            self.showChatController(forUser: user)
        }
    }
}

extension ConversationsController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}

extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true) {
            self.viewDidLoad()
        }
    }
}
