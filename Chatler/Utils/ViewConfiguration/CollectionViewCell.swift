//
//  CollectionViewCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit
import JGProgressHUD

class CollectionViewCell: UICollectionViewCell, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    private let hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecicle
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

// MARK: - Helpers

extension CollectionViewCell: BaseCellProtocol {
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
}
