//
//  ProductsCollectionViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell, IdentifiableProtocol {
    
    private let discountBadge: UILabel = {
        let label = UILabel()
        label.text = "-20%"
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "⭐️ 4.5 (123)"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let brandNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand Name"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$49.99"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "$59.99"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        let attributedText = NSMutableAttributedString(string: label.text!)
        attributedText.addAttribute(.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: NSRange(location: 0, length: label.text!.count))
        label.attributedText = attributedText
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Layout the UI
    private func setupViews() {
        // Add subviews
        contentView.addSubview(discountBadge)
        contentView.addSubview(productImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(brandNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(favoriteButton)
        
        // Set constraints
        discountBadge.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        brandNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        originalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            discountBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            discountBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            discountBadge.widthAnchor.constraint(equalToConstant: 40),
            discountBadge.heightAnchor.constraint(equalToConstant: 20),
            
            productImageView.topAnchor.constraint(equalTo: discountBadge.bottomAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            brandNameLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            brandNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            productNameLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            originalPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}

