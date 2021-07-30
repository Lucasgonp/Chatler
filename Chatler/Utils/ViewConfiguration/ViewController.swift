//
//  ViewController.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import UIKit
import JGProgressHUD

public protocol ViewConfiguration: AnyObject {
    func showLoading(text: String?)
    func hideLoading()
    
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

open class ViewController: UIViewController, ViewConfiguration {
    private let hud = JGProgressHUD(style: .dark)
    
    open func showLoading(text: String? = "Loading...") {
        view.endEditing(true)
        hud.textLabel.text = text
        hud.show(in: view)
        return
    }
    
    open func hideLoading() {
        hud.dismiss()
    }
    
    open func hideLoading(completion: @escaping () ->()) {
        hud.dismiss()
        completion()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    open func configureUI() {}
    
    open func buildViewHierarchy() {}
    
    open func configureViews() {}
    
    open func setupConstraints() {}
}
