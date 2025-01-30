//
//  ProductsCollectionViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import UIKit
import Combine

final class ProductCollectionCell: UICollectionViewCell, IdentifiableProtocol {
    private let viewModel = DefaultProductCollectionCellViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 2

        return button
    }()
    
    private lazy var saleBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var saleBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 11)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 14)
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 12)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addShadow()
        setupViews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        [productImageView, favoriteButton, saleBadgeView, brandNameLabel,
         productNameLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
        saleBadgeView.addSubview(saleBadgeLabel)
        
        setupConstraints()
    }
    
    private func setupBindings() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .imageLoaded(let image):
                    self?.productImageView.image = image ?? UIImage(systemName: "photo")
                    self?.productImageView.tintColor = image == nil ? .systemGray3 : nil
                case .favouriteStatusChanged:
                    self?.updateFavouriteButton()
                case .showError(let errorMessage):
                    print("Image load error: \(errorMessage)")
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setupConstraints() {
        [productImageView, brandNameLabel, productNameLabel, priceLabel,
         saleBadgeView, saleBadgeLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            favoriteButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -padding),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -padding),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            saleBadgeView.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: padding + 4),
            saleBadgeView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: padding - 4),
            saleBadgeView.widthAnchor.constraint(equalToConstant: 30),
            saleBadgeView.heightAnchor.constraint(equalToConstant: 25),
            
            saleBadgeLabel.centerXAnchor.constraint(equalTo: saleBadgeView.centerXAnchor),
            saleBadgeLabel.centerYAnchor.constraint(equalTo: saleBadgeView.centerYAnchor),
            
            brandNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: padding),
            brandNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            brandNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            productNameLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: padding),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configureCell(with product: Product) {
        viewModel.product = product
        
        let imageSize = CGSize(width: bounds.width - 16, height: bounds.width - 16)
        viewModel.loadImage(urlString: product.image, size: imageSize)
        
        brandNameLabel.text = product.brand?.isEmpty == true ? "Not Branded" : product.brand
        productNameLabel.text = product.title
        priceLabel.text = "$\(product.price.totalAmount.amount)"
        
        saleBadgeView.isHidden = product.discountPercentage <= 0
        saleBadgeLabel.text = product.discountPercentage > 0 ? "\(Int(product.discountPercentage))%" : nil
        
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        favoriteButton.setImage(
            UIImage(systemName: viewModel.isFavourite ? "heart.fill" : "heart"),
            for: .normal
        )
        favoriteButton.tintColor = viewModel.isFavourite ? .red : .white
    }
    
    @objc private func toggleFavorite() {
        guard viewModel.product != nil else { return }
        viewModel.favouritesTapped()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
        saleBadgeView.isHidden = true
        viewModel.cancelLoading()
    }
}
