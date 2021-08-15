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
    let activityIndicator = ActivityIndicator().spinner
    
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

    // MARK: - Helpers

extension View {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.veryLightGray.cgColor, Colors.mainWhite.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func configureGradientLayerSecundary() {
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.veryLightGray.cgColor, Colors.mainWhite.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func configureGradientLayerThird() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [Colors.mainColor.withAlphaComponent(0.1).cgColor, Colors.mainWhite.cgColor, Colors.mainWhite.cgColor, Colors.mainColor.withAlphaComponent(0.1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [-0.7, 0.25, 0.75, 1.7]
        layer.addSublayer(gradient)
    }
    
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
