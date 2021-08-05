//
//  NewMessageController.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageDelegate: AnyObject {
    func controller(_ controller: TableViewController,
                    wantsToStartChatWith user: User)
}

protocol NewMessageDelegateOutput: BaseOutputProtocol {
    func reloadTableView(withUsers users: [User])
}

class NewMessageController: TableViewController, NewMessageDelegateOutput {
    // MARK: - Properties
    
    private lazy var viewModel: NewMessageViewModelDelegate = NewMessageViewModel()
    weak var delegate: NewMessageDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users = [User]()
    private var filteredUser = [User]()
    
    private var isSearchMode: Bool {
        return searchController.isActive &&
            !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    
    init() {
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
        configureSearchController()
    }
    
    override func setupConstraints() {}
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Strings.NewMessage.searchForUser
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = Colors.mainColor
            textField.backgroundColor = .white
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    func getUsers() {
        viewModel.loadUsers()
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        print("DEBUG: - SEARHC is \(searchText)")
        filteredUser = users.filter({ user -> Bool in
            return user.username.containsIgnoringCase(find: searchText) || user.fullname.containsIgnoringCase(find: searchText)
            
        })
        self.tableView.reloadData()
    }
}

    // MARK: Output

extension NewMessageController {
    func reloadTableView(withUsers users: [User]) {
        self.users = users
        tableView.reloadData()
    }
}

    // MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell else { return defaultCell }
        cell.user = isSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        return cell
    }
}

    // MARK: - SelectingCell

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToStartChatWith: user)
    }
}
