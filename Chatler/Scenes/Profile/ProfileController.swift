//
//  ProfileController.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "profileCell"

protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
}

class ProfileController: TableViewController {
    
    //MARK: - Properties
    
    weak var delegate: ProfileControllerDelegate?
    private let viewModel: ProfileViewModelInput = ProfileViewModel()
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    private lazy var footerView: ProfileFooterView = {
        let footer = ProfileFooterView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
        return footer
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        
        configureTableView()
    }

    override func buildViewHierarchy() {
        
    }
    
    override func setupConstraints() {
        
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    
    func loadUser() {
        viewModel.loadUser()
    }
    
    //MARK: - Helpers
    
}

// MARK: - Privates

private extension ProfileController {
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = footerView
        
        footerView.delegate = self
    }
    
    func handleDidSelectRowAt(collectionModel: ProfileViewModelCollection) {
        switch collectionModel {
        case .accountInfo:
            return
        case .setting:
            return
        }
    }
    
    func presentLoginScreen() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

    // MARK: - UITableViewDataSource

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModelCollection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModelCollection(rawValue: indexPath.row)
        cell.collectionDelegate = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

    // MARK: - UITableViewDataDelegate

extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collectionViewModel = ProfileViewModelCollection(rawValue: indexPath.row
        ) else { return }
        handleDidSelectRowAt(collectionModel: collectionViewModel)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

    // MARK: - Outputs

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss()
    }
    
    func imageTapped(imageView: UIImageView) {
        let controller = ImageViewFullscreen(imageView: imageView)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        
        present(controller, animated: true)
    }
}

extension ProfileController: ProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: Strings.Profile.logoutQuestion, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Strings.Profile.logout, style: .destructive) { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }
        let cancelAction = UIAlertAction(title: Strings.Main.cancel, style: .cancel, handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileController: ProfileViewModelOutput {
    func didLoadUser(user: User) {
        self.user = user
    }
}
