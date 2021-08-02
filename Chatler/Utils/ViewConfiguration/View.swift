//
//  View.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit
import JGProgressHUD

class View: UIView, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    private let hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecicle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildLayout()
        hideKeyboardWhenTappedAround()
    }
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

    // MARK: - Keyboard

extension View {
    func setupViewWithKeyboardHeight(height: CGFloat = 88) {
        keyboardHeight = height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

    // MARK: - Private

private extension View {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc func keyboardWillShow(_ height: CGFloat) {
        if frame.origin.y == 0 {
            frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide() {
        if frame.origin.y != 0 {
            frame.origin.y = 0
        }
    }
}
