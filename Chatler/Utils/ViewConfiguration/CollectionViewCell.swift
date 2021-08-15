//
//  CollectionViewCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Lifecicle
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

// MARK: - Helpers

extension CollectionViewCell: BaseCellProtocol {
    func showLoadingIndicatorActivity() {
        //
    }
    
    func hideLoadingIndicatorActivity() {
        //
    }
    
    func showError(_ errorMessage: String) {
        // 
    }
}
