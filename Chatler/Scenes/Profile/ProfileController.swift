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
    
    private lazy var childViewController: UIViewController = {
        let controller = UIViewController()
        controller.view.backgroundColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        controller.view.addGestureRecognizer(tap)
        return controller
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
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func configureUI() {
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        view.addGestureRecognizer(tap)
        
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
    
    func handleDidSelectRowAt(collectionModel: profileViewModelCollection) {
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
        return profileViewModelCollection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = profileViewModelCollection(rawValue: indexPath.row)
        cell.collectionDelegate = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
    // MARK: - UITableViewDataDelegate
extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collectionViewModel = profileViewModelCollection(rawValue: indexPath.row
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
        
//        childViewController.view.addSubview(imageView)
//
//
//
//        childViewController.modalTransitionStyle = .crossDissolve
//        childViewController.modalPresentationStyle = .fullScreen
//        present(childViewController, animated: true) {
//            imageView.snp.makeConstraints {
//                $0.center.equalToSuperview()
//            }
//        }
        
        /*func imageTapped(imageView: UIImageView) {
         let newImageView = UIImageView(image: imageView.image)
         newImageView.frame = UIScreen.main.bounds
         newImageView.backgroundColor = .clear
         newImageView.contentMode = .scaleAspectFit
         newImageView.isUserInteractionEnabled = true
         let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
         newImageView.addGestureRecognizer(tap)
         self.view.addSubview(newImageView)
     }

     @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
         sender.view?.removeFromSuperview()
     }*/
        
        
//
//        imageView.snp.makeConstraints {
//            $0.center.equalTo(imageView.center)
//        }

//        self.view.addSubview(imageView3)
//        imageView.center = view.center
//
//
//        animate(newImageView)
    }
    
    func animate(_ image: UIImageView) {
        image.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            image.snp.remakeConstraints {
                $0.center.equalTo(self.view.snp.center)
            }
            
            image.center = self.view.center
            image.alpha = 1
        }) { (success: Bool) in
            print("Done moving image")
        }
        
        
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
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
        print("username is \(user.username)")
        self.user = user
    }
}
