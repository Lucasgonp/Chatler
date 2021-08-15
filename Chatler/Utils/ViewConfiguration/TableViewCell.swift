//
//  TableViewCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit

protocol BaseCellProtocol: AnyObject {
    func showError(_ errorMessage: String)
}

class TableViewCell: UITableViewCell, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
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
    func showError(_ errorMessage: String) {
        // 
    }
}
