//
//  CustomButton.swift
//  Chatler
//
//  Created by Lucas Pereira on 28/07/21.
//

import UIKit

class PrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = Colors.confirmButton
        setTitleColor(.white, for: .normal)
        setHeight(height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SecundaryButton: UIButton {
    init(textTitle: String, textAction: String, action: Selector? = nil, target: Any?) {
        super.init(frame: .zero)
        
        let attributedTitle = NSMutableAttributedString(string: textTitle,
                                                        attributes: [.font: Fonts.defaultLight(size: 16),
                                                                     .foregroundColor: Colors.firstColor])
        attributedTitle.append(NSAttributedString(string: textAction,
                                                  attributes: [.font: Fonts.defaultBold(size: 18),
                                                               .foregroundColor: Colors.firstColor]))
        
//        let attributedTitle = NSMutableAttributedString(string: Strings.Register.alreadyHaveAccountTextButton,
//                                                        attributes: [.font: Fonts.defaultLight(size: 16),
//                                                                     .foregroundColor: Colors.firstColor])
//        attributedTitle.append(NSAttributedString(string: Strings.Register.alreadyAccountActionButton,
//                                                  attributes: [.font: Fonts.defaultBold(size: 18),
//                                                               .foregroundColor: Colors.firstColor]))
        
        setAttributedTitle(attributedTitle, for: .normal)
        addTarget(target, action: action  ?? #selector(defaultAction), for: .touchUpInside)
    }
    
    @objc func defaultAction() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
