//
//  ProductsCollectionViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import UIKit
import Combine

final class ProductCollectionCell: UICollectionViewCell, IdentifiableProtocol {
    private let imageViewModel = DefaultProductImageViewModel()
    
    private var imageCancellable: AnyCancellable?
    
    var product: Product?
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
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
        contentView.addSubview(brandNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(saleBadgeView)
        saleBadgeView.addSubview(saleBadgeLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [productImageView, brandNameLabel, productNameLabel, priceLabel, saleBadgeView, saleBadgeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
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
        self.product = product
        let imageSize = CGSize(width: bounds.width / 2.5, height: bounds.height / 2.5)
        
        imageViewModel.loadImage(urlString: product.image, size: imageSize)
        
        imageCancellable = imageViewModel.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard self?.product?.image == product.image else { return }
                self?.productImageView.image = image ?? UIImage(systemName: "photo")
            }
        
        if product.brand?.isEmpty == true {
            brandNameLabel.text = "Not Branded"
        } else {
            brandNameLabel.text = product.brand
        }
        productNameLabel.text = product.title
        priceLabel.text = "$\(product.price.totalAmount.amount)"
        
        if product.discountPercentage > 0 {
            saleBadgeView.isHidden = false
            saleBadgeLabel.text = "\(Int(product.discountPercentage))%"
        } else {
            saleBadgeView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageViewModel.cancelLoading()
        imageCancellable?.cancel()
        imageCancellable = nil
        
        product = nil
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
        saleBadgeView.isHidden = true
    }
}
