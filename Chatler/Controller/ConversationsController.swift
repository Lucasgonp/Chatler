//
//  ConversationsController.swift
//  Chatler
//
//  Created by Lucas Pereira on 26/07/21.
//

import UIKit

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController {
    
    // MARK:- Proprieties
    private var profileButton: UIBarButtonItem = {
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
    
    // MARK:- Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK:- Proprieties
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: Strings.Conversations.title, prefersLargeTitles: true)
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func showProfile() {
        
    }
}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
