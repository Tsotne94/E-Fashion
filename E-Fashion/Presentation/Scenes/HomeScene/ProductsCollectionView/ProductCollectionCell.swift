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
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(productImageView)
        
        contentView.addSubview(favoriteButton)
        contentView.addSubview(saleBadgeView)
        saleBadgeView.addSubview(saleBadgeLabel)
        contentView.addSubview(brandNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [productImageView, brandNameLabel, productNameLabel, priceLabel,
         saleBadgeView, saleBadgeLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            favoriteButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -8),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            saleBadgeView.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 12),
            saleBadgeView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 4),
            saleBadgeView.widthAnchor.constraint(equalToConstant: 30),
            saleBadgeView.heightAnchor.constraint(equalToConstant: 25),
            
            saleBadgeLabel.centerXAnchor.constraint(equalTo: saleBadgeView.centerXAnchor),
            saleBadgeLabel.centerYAnchor.constraint(equalTo: saleBadgeView.centerYAnchor),
            
            brandNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            brandNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            brandNameLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 25),
            
            productNameLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productNameLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 25),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 25),
        ])
    }
    
    func configureCell(with product: Product) {
        viewModel.product = product
        
        let imageSize = CGSize(width: bounds.width / 2.5, height: bounds.height / 2.5)
        
        viewModel.loadImage(urlString: product.image, size: imageSize)
        viewModel.loadFavouritesState()
        
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .imageLoaded(let image):
                    guard self.viewModel.product?.image == product.image else { return }
                    self.productImageView.image = image ?? UIImage(systemName: "photo")
                case .favouriteStatusChanged:
                    self.updateFavouriteButton()
                case .showError(let errorMessage):
                    print("Image load error: \(errorMessage)")
                }
            }.store(in: &subscriptions)
        
        brandNameLabel.text = product.brand?.isEmpty == true ? "Not Branded" : product.brand
        productNameLabel.text = product.title
        priceLabel.text = "$\(product.price.totalAmount.amount)"
        
        updateFavouriteButton()
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        saleBadgeView.isHidden = product.discountPercentage <= 0
        saleBadgeLabel.text = product.discountPercentage > 0 ? "\(Int(product.discountPercentage))%" : nil
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
        
//        viewModel.cancelLoading()
//        subscriptions.forEach { cancellable in
//            cancellable.cancel()
//        }
        
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
        saleBadgeView.isHidden = true
        viewModel.product = nil
        
        updateFavouriteButton()
    }
}
