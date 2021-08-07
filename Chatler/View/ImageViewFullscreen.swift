//
//  ImageViewFullscreen.swift
//  Chatler
//
//  Created by Lucas Pereira on 06/08/21.
//

import UIKit

class ImageViewFullscreen: UIViewController {
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = false
        return image
    }()
    
    init(imageView: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = imageView.image
        view.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.isUserInteractionEnabled = true
        view.gestureRecognizers?.removeAll()
        view.addGestureRecognizer(tap)
        
        buildViewHierarchy()
        setupConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top).offset(50)
            $0.height.width.equalTo(300)
        }
        
        
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
