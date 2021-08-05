//
//  Extensions.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit
import SnapKit
import JGProgressHUD

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
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Encodable {
  /// Returns a JSON dictionary, with choice of minimal information
  func getDictionary() -> [String: Any]? {
    let encoder = JSONEncoder()

    guard let data = try? encoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
    }
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

extension Decodable {
  /// Initialize from JSON Dictionary. Return nil on failure
  init?(dictionary value: [String:Any]){

    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }

    guard let newValue = try? JSONDecoder().decode(Self.self, from: jsonData) else { return nil }
    self = newValue
  }
}

//extension UIView {
//    func anchor(top: NSLayoutYAxisAnchor? = nil,
//                left: NSLayoutXAxisAnchor? = nil,
//                bottom: NSLayoutYAxisAnchor? = nil,
//                right: NSLayoutXAxisAnchor? = nil,
//                paddingTop: CGFloat = 0,
//                paddingLeft: CGFloat = 0,
//                paddingBottom: CGFloat = 0,
//                paddingRight: CGFloat = 0,
//                width: CGFloat? = nil,
//                height: CGFloat? = nil) {
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        if let top = top {
//            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
//        }
//
//        if let left = left {
//            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
//        }
//
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
//        }
//
//        if let right = right {
//            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
//        }
//
//        if let width = width {
//            widthAnchor.constraint(equalToConstant: width).isActive = true
//        }
//
//        if let height = height {
//            heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
//
//    func centerX(inView view: UIView) {
//        translatesAutoresizingMaskIntoConstraints = false
//        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    }
//
//    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
//                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
//
//        translatesAutoresizingMaskIntoConstraints = false
//        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
//
//        if let left = leftAnchor {
//            anchor(left: left, paddingLeft: paddingLeft)
//        }
//    }
//
//    func setDimensions(height: CGFloat, width: CGFloat) {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: height).isActive = true
//        widthAnchor.constraint(equalToConstant: width).isActive = true
//    }
//
//    func setHeight(height: CGFloat) {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: height).isActive = true
//    }
//
//    func setWidth(width: CGFloat) {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: width).isActive = true
//    }
//}
