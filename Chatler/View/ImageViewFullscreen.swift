//
//  ImageViewFullscreen.swift
//  Chatler
//
//  Created by Lucas Pereira on 06/08/21.
//

import UIKit

protocol ImageFullscreenProtocol: AnyObject {
    func dragImageView()
    func handleDragEnded()
}

class ImageViewFullscreen: UIViewController {
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 200 / 2
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private var dragGestureFinish = UIPanGestureRecognizer()
    
    init(imageView: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = imageView.image
        view.backgroundColor = .darkGray.withAlphaComponent(0.9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func buildViewHierarchy() {
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.frame.size = CGSize(width: 200, height: 200)
        imageView.center.x = view.center.x
        imageView.center.y = 196
    }
    
    func configureViews() {
        dragGestureFinish.delegate = self
        dragGestureFinish = UIPanGestureRecognizer(target: self, action: #selector(dragged))
        imageView.addGestureRecognizer(dragGestureFinish)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.imageView.layer.cornerRadius = 0
            self.imageView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.center.y - self.imageView.frame.height, width: self.view.frame.width, height: self.view.frame.width)
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    @objc func dragged() {
        switch dragGestureFinish.state {
        case .ended:
            handleDragEnded()
        default:
            dragImageView()
        }
    }
    
    @objc func dismissView() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = .white.withAlphaComponent(0)
            self.imageView.layer.cornerRadius = 200 / 2
            self.imageView.frame.size = CGSize(width: 200, height: 200)
            self.imageView.center.x = self.view.center.x
            self.imageView.center.y = 196
        } completion: { finish in
            self.dismiss(animated: true)
        }
    }
}

extension ImageViewFullscreen: ImageFullscreenProtocol {
    func dragImageView() {
        self.view.bringSubviewToFront(imageView)
        let translation = dragGestureFinish.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        dragGestureFinish.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func handleDragEnded() {
        let centerX = abs(imageView.center.x)
        let centerY = abs(imageView.center.y)
        let point = CGPoint(x: centerX, y: centerY)
        
        if distance(point, view.center) > 350 {
            dismissView()
        } else {
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.imageView.center = self.view.center
            }
        }
    }
}

extension ImageViewFullscreen: UIGestureRecognizerDelegate {}
