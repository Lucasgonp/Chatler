//
//  InputContainerView.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit
import SnapKit

class InputContainerView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Colors.mainWhite
        imageView.alpha = 0.87
        
        return imageView
    }()
    
    let deviderView: UIView = {
        let deviderView = UIView()
        deviderView.backgroundColor = Colors.secundaryColor
        
        return deviderView
    }()
    
    init(image: UIImage?, textField: UITextField) {
        super.init(frame: .zero)
        
        imageView.image = image
        
        addSubview(imageView)
        addSubview(textField)
        addSubview(deviderView)
        
        snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(snp_leftMargin).offset(8)
            $0.height.width.equalTo(24)
        }
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.bottom.equalTo(snp.bottomMargin).offset(8)
            $0.right.equalTo(snp.rightMargin)
        }
        
        deviderView.snp.makeConstraints {
            $0.left.equalTo(snp_leftMargin).offset(8)
            $0.bottom.equalTo(snp_bottomMargin)
            $0.right.equalTo(snp_rightMargin)
            $0.height.equalTo(0.75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
