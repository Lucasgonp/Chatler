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
        let img = UIImage(systemName: "person.circle.fill")
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
        
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        let appearane = UINavigationBarAppearance()
        appearane.configureWithOpaqueBackground()
        appearane.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearane.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearane
        navigationController?.navigationBar.compactAppearance = appearane
        navigationController?.navigationBar.scrollEdgeAppearance = appearane
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
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
