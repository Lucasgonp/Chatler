//
//  ProfileController.swift
//  Chatler
//
//  Created by Lucas Pereira on 03/08/21.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "profileCell"

class ProfileController: TableViewController {
    //MARK: - Properties
    private let viewModel: ProfileViewModelInput = ProfileViewModel()
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    
    //MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
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
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    
    //MARK: - Selectors
    
    //MARK: - API
    func loadUser() {
        viewModel.loadUser()
    }
    
    //MARK: - Helpers
    func logout() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Signed out!")
            
            presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out: \(error.localizedDescription)")
        }
    }
    
    func presentLoginScreen() {
            let viewModel = LoginViewModel()
            let controller = LoginController(viewModel: viewModel)
            viewModel.controller = controller
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

    // MARK: - Outputs
extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss()
    }
}

extension ProfileController: ProfileViewModelOutput {
    func didLoadUser(user: User) {
        print("username is \(user.username)")
        self.user = user
    }
}
