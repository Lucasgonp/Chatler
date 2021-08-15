//
//  ViewController.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import UIKit

public protocol BaseOutputProtocol: AnyObject {
    func dismiss()
    func showError(_ errorMessage: String)
}

public protocol ViewConfiguration: AnyObject {
    func configureUI()
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
    
}

public extension ViewConfiguration {
    func buildLayout() {
        configureUI()
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
}

class ViewController: UIViewController, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    let activityIndicator = ActivityIndicator().spinner
    var isDark = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Lifecicle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildLayout()
        hideKeyboardWhenTappedAround()
    }
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

    // MARK: - Outputs

extension ViewController: BaseOutputProtocol {
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showDialog(title: String = "Ops!", text: String) {
        //
    }
}

    // MARK: - Helpers

extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDark ? .lightContent : .default
    }

    func toggleAppearance() {
       isDark.toggle()
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.mainColor.cgColor, Colors.mainWhite.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func configureGradientLayerSecundary() {
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.veryLightGray.cgColor, Colors.mainWhite.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func setupViewWithKeyboardHeight(height: CGFloat = 88) {
        keyboardHeight = height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

    // MARK: - Private

private extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ height: CGFloat) {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
