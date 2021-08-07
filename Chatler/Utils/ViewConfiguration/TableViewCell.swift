//
//  TableViewCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit
import JGProgressHUD

protocol BaseCellProtocol: AnyObject {
    func showLoading()
    func showLoading(text: String)
    func hideLoading()
    func hideLoading(completion: @escaping () -> ())
}

class TableViewCell: UITableViewCell, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    private let hud = JGProgressHUD(style: .dark)
    let activityIndicator = ActivityIndicator().spinner
    
    // MARK: - Lifecicle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildLayout()
    }
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

// MARK: - Helpers

extension TableViewCell: BaseCellProtocol {
    func showLoading() {
        contentView.endEditing(true)
        
        let text = "Loading..."
        hud.textLabel.text = text
        hud.show(in: contentView)
        
        return
    }
    
    func showLoading(text: String) {
        contentView.endEditing(true)
        hud.textLabel.text = text
        hud.show(in: contentView)
        return
    }
    
    func hideLoading() {
        hud.dismiss()
    }
    
    func hideLoading(completion: @escaping () -> ()) {
        hud.dismiss()
        completion()
    }
    
    func showError(_ errorMessage: String) {
        // 
    }
}
