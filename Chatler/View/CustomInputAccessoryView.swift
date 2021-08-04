//
//  CustomInputAccessoryView.swift
//  Chatler
//
//  Created by Lucas Pereira on 02/08/21.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

class CustomInputAccessoryView: View {
    
    // MARK: - Properties
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var messageInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = Fonts.defaultLight(size: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = Fonts.defaultBold(size: 16)
        button.setTitleColor(Colors.confirmButton, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        return button
    }()
    
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Enter message"
        label.font = Fonts.defaultLight(size: 16)
        label.textColor = .lightGray
        
        return label
    }()
    
    // MARK: - Lifecicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewHierarchy() {
        addSubview(sendButton)
        addSubview(messageInputTextView)
        addSubview(placeholderLabel)
    }
    
    override func configureViews() {
        
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override func setupConstraints() {
        sendButton.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(4)
            $0.right.equalTo(snp.right).offset(-8)
            $0.height.width.equalTo(50)
        }
        
        messageInputTextView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(12)
            $0.left.equalTo(snp.left).inset(8)
            $0.right.equalTo(sendButton.snp.left).offset(-8)
            $0.bottom.equalTo(snp.bottomMargin).inset(10)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.left.equalTo(messageInputTextView.snp.left).offset(8)
            $0.centerY.equalTo(messageInputTextView.snp.centerY)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Selectors
    
    @objc func handleSendMessage() {
        guard let text = messageInputTextView.text else { return }
        delegate?.inputView(self, wantsToSend: text)
    }
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !messageInputTextView.text.isEmpty
    }
    
    // MARK: - Helpers
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
}
