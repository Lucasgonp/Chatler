//
//  Extensions.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit
import SnapKit
import JGProgressHUD

private let activityIndicator = ActivityIndicator()

extension UIViewController {
    public static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text

        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = Colors.navigationBar
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.largeTitleDisplayMode = prefersLargeTitles ? .always : .never
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        
        //navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func showLoadingIndicatorActivity() {
        addChild(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParent: self)
    }
    
    func hideLoadingIndicatorActivity() {
        activityIndicator.willMove(toParent: nil)
        activityIndicator.view.removeFromSuperview()
        activityIndicator.removeFromParent()
    }
    
    func showInteractiveModal(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: Strings.Main.cancel, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ errorMessage: String) {
        let title = Strings.ErrorHandling.genericTitle
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ErrorHandling.genericButton, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            
            self.backgroundColor = .clear
            titleLabel?.layer.opacity = 0
            setTitleColor(.clear, for: .disabled)
            
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            
            self.backgroundColor = Colors.confirmButton
            titleLabel?.layer.opacity = 1
            setTitleColor(titleColor(for: .normal), for: .disabled)
            
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
