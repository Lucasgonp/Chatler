//
//  FriendCell.swift
//  Chatler
//
//  Created by Lucas Pereira on 11/08/21.
//

import UIKit

class FriendCell: TableViewCell {
    
    // MARK: - Properties
    var collectionDelegate: FriendViewModelCollection? {
        didSet {
            configure()
        }
    }
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        view.layer.cornerRadius = 40 / 2
        return view
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.defaultLight(size: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildViewHierarchy() {
        iconView.addSubview(iconImage)
        addSubview(stack)
    }
    
    override func setupConstraints() {
        iconView.snp.makeConstraints {
            $0.height.width.equalTo(40)
        }
        
        iconImage.snp.makeConstraints {
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.centerY.equalTo(iconView.snp.centerY)
            $0.height.width.equalTo(28)
        }
        
        stack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(snp.left).offset(12)
        }
    }
    
    // MARK: - Selectors

    // MARK: - API

    // MARK: - Helpers
}

private extension FriendCell {
    func configure() {
        guard let viewModel = collectionDelegate else { return }
        iconImage.image = viewModel.iconImage
        titleLabel.text = viewModel.description
    }
}
