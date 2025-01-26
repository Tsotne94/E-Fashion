//
//  CategoryCollectionViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, IdentifiableProtocol {
    let tagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .accentBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    var pressed = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        setupTagButton()
    }
    
    private func setupTagButton() {
        contentView.addSubview(tagButton)
        tagButton.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tagButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tagButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configureCell(with category: String) {
        tagButton.setTitle("   \(category)   ", for: .normal)
        layoutIfNeeded()
    }
}
