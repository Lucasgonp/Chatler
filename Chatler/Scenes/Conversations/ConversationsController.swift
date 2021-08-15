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
    var tableView: UITableView { get }
    
    func presentLoginScreen()
    func onAuthenticate()
    func onLoadConversations(conversations: [Conversation])
    func onOpenChat(with user: User)
}

class ConversationsController: ViewController {
    
    // MARK: - Proprieties
    
    private let viewModel: ConversationsViewModelInput = ConversationsViewModel()
    
    private lazy var profileButton: UIBarButtonItem = {
        let img = Images.Login.profile
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(showProfile))
        item.tintColor = Colors.gray
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        viewModel.authenticate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.layoutIfNeeded()
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
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationCell
        cell?.conversation = viewModel.conversations[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
}

    // MARK: - UITableViewDelegate
extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectConversation(indexPath.row)
    }
}

    // MARK: - Outputs
extension ConversationsController: ConversationsViewModelOutput {
    func onAuthenticate() {
        loadConversations()
    }
    
    func onPresentLoginScreen() {
        presentLoginScreen()
    }
    
    func onOpenChat(with user: User) {
        showChatController(forUser: user)
    }
    
    func onLoadConversations(conversations: [Conversation]) {
        conversations.forEach { conversation in
            let message = conversation.message
            viewModel.conversationsDictionary[message.chatPartnerId] = conversation
            
        }
        
        viewModel.conversations = Array(viewModel.conversationsDictionary.values)
        tableView.reloadData()
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
        viewModel.logout()
    }
}

extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true) {
            self.viewDidLoad()
        }
    }
}
