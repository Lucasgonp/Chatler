//
//  FriendInfoController.swift
//  Chatler
//
//  Created by Lucas Pereira on 09/08/21.
//

import UIKit

private let reuseIdentifier = "friendCell"

class FriendInfoController: TableViewController {
    
    // MARK: - Properties
    
    private let viewModel: FriendInfoViewModelInput = FriendInfoViewModel()
    var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = FriendHeader(frame: .init(x: 0, y: 0,
                                                            width: view.frame.width,
                                                            height: 380))
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        viewModel.output = self
        
    }
    
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers
    
}

// MARK: - Private Helpers

private extension FriendInfoController {
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: reuseIdentifier)
        //tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView()
    }
    
    func handleDidSelectRowAt(collectionModel: FriendViewModelCollection) {
        switch collectionModel {
        case .sharedImages:
            return
        }
    }
}

// MARK: - UITableViewDataSource

extension FriendInfoController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendViewModelCollection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        let viewModel = FriendViewModelCollection(rawValue: indexPath.row)
        cell.collectionDelegate = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDataDelegate

extension FriendInfoController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collectionViewModel = FriendViewModelCollection(rawValue: indexPath.row
        ) else { return }
        handleDidSelectRowAt(collectionModel: collectionViewModel)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Outputs

extension FriendInfoController: FriendInfoViewModelOutput {
    func didLoadUser(user: User) {
        self.user = user
    }
}

extension FriendInfoController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss()
    }
    
    func imageTapped(imageView: UIImageView) {
        let controller = ImageViewFullscreen(imageView: imageView)
        controller.centerY = 220
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        
        present(controller, animated: true)
    }
}
