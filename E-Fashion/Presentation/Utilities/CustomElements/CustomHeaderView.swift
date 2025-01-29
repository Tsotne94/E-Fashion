//
//  CustomHeaderView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 25.01.25.
//

import UIKit

class CustomHeaderView: UIView {
    var backButtonTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentBlack
        label.textAlignment = .center
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: Icons.back), for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(title: String, showBackButton: Bool = true) {
        self.init(frame: .zero)
        setTitle(title)
        configureBackButton(isVisible: showBackButton)
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func configureBackButton(isVisible: Bool) {
        backButton.isHidden = !isVisible
    }
    
    private func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        setupConstraints()
        setupBackButtonAction()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    
    private func setupBackButtonAction() {
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc private func backButtonPressed() {
        backButtonTapped?()
    }
}
