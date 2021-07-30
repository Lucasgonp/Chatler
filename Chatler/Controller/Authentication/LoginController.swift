//
//  LoginController.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import SnapKit
import FirebaseAuth
import JGProgressHUD
import UIKit

protocol LoginControllerDelegate {
    func showLoading(text: String?)
    func checkFormStatus()
    func hideLoading()
    func dismiss()
}

class LoginController: ViewController {
    
    // MARK: - Proprieties
    
    private let viewModel: LoginViewModel
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.Login.profileBubble
        imageView.tintColor = Colors.secondColor
        
        return imageView
    }()
    
    private lazy var emailContainerView = InputContainerView(image: Images.Login.envelope, textField: emailTextField)
    
    private lazy var passwordContainerView = InputContainerView(image: Images.Login.lock, textField: passwordTextField)
    
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton(title: Strings.Login.loginButton, action: #selector(handleLogin), target: self)
        button.backgroundColor = .systemGray5
        button.isEnabled = false
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: Strings.Login.emailPlaceholder)
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: Strings.Login.passwordPlaceholder)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = SecundaryButton(textTitle: Strings.Login.dontHaveAccountTextButton,
                                     textAction: Strings.Login.dontHaveAccountActionButton,
                                     action: #selector(handleShowSignUp),
                                     target: self)
        return button
    }()
    
    // MARK: - Lifecicle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        setupNavigationBar()
        configureGradientLayer()

    }
    
    override func buildViewHierarchy() {
        view.addSubview(iconImage)
        view.addSubview(stackView)
        view.addSubview(dontHaveAccountButton)
    }
    
    override func configureViews() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func setupConstraints() {
        iconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalTo(view.snp.topMargin).offset(32)
            $0.height.width.equalTo(120)
        }
        
        stackView.snp.makeConstraints {
            $0.topMargin.equalTo(iconImage.snp.bottom).offset(32)
            $0.leftMargin.equalTo(view.snp.left).offset(32)
            $0.rightMargin.equalTo(view.snp.right).offset(-32)
        }
        
        dontHaveAccountButton.snp.makeConstraints{
            $0.bottom.equalTo(view.snp.bottomMargin)
            $0.left.equalTo(view.snp.leftMargin).offset(32)
            $0.right.equalTo(view.snp.rightMargin).offset(-32)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        viewModel.doLogin()
    }
    
    @objc func handleShowSignUp() {
        
        let controller = signUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func signUpController() -> ViewController {
        let viewModel = RegistrationViewModel()
        let controller = RegistrationController(viewModel: viewModel)
        viewModel.controller = controller
        
        return controller
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    

    // MARK: - Helpers
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureRegisterButton() {
     //   dontHaveAccountButton.anchor()
    }
}

extension LoginController: LoginControllerDelegate {
    func dismiss() {
        hideLoading {
            self.dismiss(animated: true)
        }
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemPurple
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .systemGray5
        }
    }
}