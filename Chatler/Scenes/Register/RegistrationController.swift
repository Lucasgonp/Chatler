//
//  RegistrationController.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

protocol RegistrationControllerDelegate: BaseOutputProtocol {}

class RegistrationController: ViewController {
    
    // MARK:- Proprieties
    
    private lazy var viewModel: RegistrationViewModelDelegate = RegistrationViewModel()
    
    private var profileImage: UIImage? {
        didSet {
            viewModel.profileImage = profileImage
        }
    }
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.Login.addPhoto, for: .normal)
        button.tintColor = Colors.mainWhite
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private let signUpButton: PrimaryButton = {
        let button = PrimaryButton(title: Strings.Register.signUpButton, action: #selector(handleSignUp), target: self)
        button.isEnabled = false
        button.backgroundColor = .systemGray5
        
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = SecundaryButton(textTitle: Strings.Register.alreadyHaveAccountTextButton,
                                     textAction: Strings.Register.alreadyHaveAccountActionButton,
                                     action: #selector(handleShowLogin),
                                     target: self)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   usernameContainerView,
                                                   passwordContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var emailContainerView = InputContainerView(image: Images.Login.envelope, textField: emailTextField)
    
    private lazy var fullNameContainerView = InputContainerView(image: Images.Login.profile, textField: fullNameTextField)
    
    private lazy var usernameContainerView = InputContainerView(image: Images.Login.profile, textField: usernameTextField)
    
    private lazy var passwordContainerView = InputContainerView(image: Images.Login.lock, textField: passwordTextField)
    
    private let emailTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Strings.Login.emailPlaceholder)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let fullNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Strings.Register.fullNamePlaceholder)
        textField.keyboardType = .namePhonePad
        return textField
    }()
    
    private let usernameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Strings.Register.usernamePlaceholder)
        textField.keyboardType = .default
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: Strings.Login.passwordPlaceholder)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // MARK:- Lifecicle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        configureGradientLayer()
    }
    
    override func buildViewHierarchy() {
        view.addSubview(plusPhotoButton)
        view.addSubview(stackView)
        view.addSubview(alreadyHaveAccountButton)
    }
    
    override func configureViews() {
        configureNotificationObservers()
        setupViewWithKeyboardHeight()
    }
    
    override func setupConstraints() {
        plusPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalTo(view.snp.topMargin).offset(32)
            $0.height.width.equalTo(200)
        }
        
        stackView.snp.makeConstraints {
            $0.topMargin.equalTo(plusPhotoButton.snp.bottom).offset(32)
            $0.leftMargin.equalTo(view.snp.left).offset(32)
            $0.rightMargin.equalTo(view.snp.right).offset(-32)
        }
        
        alreadyHaveAccountButton.snp.makeConstraints{
            $0.bottom.equalTo(view.snp.bottomMargin)
            $0.left.equalTo(view.snp.leftMargin).offset(32)
            $0.right.equalTo(view.snp.rightMargin).offset(-32)
        }
    }
    
    //MARK: - Helpers
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleSignUp() {
        viewModel.loadSignUpUser()
        
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

extension RegistrationController: RegistrationControllerDelegate {
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemPurple
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .systemGray5
        }
    }
}

    // MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
        
        checkFormStatus()
        dismiss(animated: true)
    }
}
