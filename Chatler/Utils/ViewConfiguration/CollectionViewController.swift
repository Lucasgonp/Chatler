//
//  CollectionViewController.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit


class CollectionViewController: UICollectionViewController, ViewConfiguration {
    private var keyboardHeight: CGFloat = 88
    let activityIndicator = ActivityIndicator().spinner
    
    // MARK: - Lifecicle
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildLayout()
        hideKeyboardWhenTappedAround()
    }
    
    public func configureUI() {}
    
    public func buildViewHierarchy() {}
    
    public func configureViews() {}
    
    public func setupConstraints() {}
}

    // MARK: - Helpers

extension CollectionViewController: BaseOutputProtocol {
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showDialog(title: String = "Ops!", text: String) {
        //
    }
}

    // MARK: - Keyboard
extension CollectionViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupViewWithKeyboardHeight(height: CGFloat = 88) {
        keyboardHeight = height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

    // MARK: - Private

private extension CollectionViewController {
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
    
    func scrollToLastItem() {
        let lastSection = collectionView.numberOfSections - 1

        let lastRow = collectionView.numberOfItems(inSection: lastSection)

        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)

        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)

    }
}

