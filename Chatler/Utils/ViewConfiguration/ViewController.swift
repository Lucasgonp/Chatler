//
//  ViewController.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import UIKit

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

open class ViewController: UIViewController, ViewConfiguration {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    open func configureUI() {}
    
    open func buildViewHierarchy() {}
    
    open func configureViews() {}
    
    open func setupConstraints() {}
}
