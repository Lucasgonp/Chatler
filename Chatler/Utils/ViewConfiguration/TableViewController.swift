//
//  TableViewController.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import UIKit

class TableViewController: UITableViewController, ViewConfiguration {
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
        view.backgroundColor = .white
        
        buildLayout()
        hideKeyboardWhenTappedAround()
    }
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

// MARK: - Helpers

extension TableViewController: BaseOutputProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDark ? .lightContent : .default
    }

    func toggleAppearance() {
       isDark.toggle()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showDialog(title: String = "Ops!", text: String) {
        //
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss()
    }
}

// MARK: - Keyboard

extension TableViewController {
    func setupViewWithKeyboardHeight(height: CGFloat = 88) {
        keyboardHeight = height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Private

private extension TableViewController {
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
