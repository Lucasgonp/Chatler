//
//  NewMessageController.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: BaseProtocol {
    var users: [User] { get set }
    
    func reloadTableView()
}

class NewMessageController: TableViewController, NewMessageControllerDelegate {
    // MARK: - Properties
    
    let viewModel: NewMessageViewModel
    
    var users = [User]()
    
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    
    init(viewModel: NewMessageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Helpers
    
    override func configureUI() {
        configureNavigationBar(withTitle: Strings.NewMessage.title, prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        configureTableView()
    }
    
    override func setupConstraints() {
        
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    func getUsers() {
        viewModel.loadUsers()
    }
}

    // MARK: Output

extension NewMessageController {
    func reloadTableView() {
        tableView.reloadData()
    }
}

    // MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell else { return defaultCell }
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
