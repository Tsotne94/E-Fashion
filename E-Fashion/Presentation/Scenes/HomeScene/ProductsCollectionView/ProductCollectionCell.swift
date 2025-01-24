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
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
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
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [productImageView, brandNameLabel, productNameLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            brandNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            brandNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func configureCell(with product: Product) {
        self.product = product
        
        let imageSize = CGSize(
            width: bounds.width / 2.5,
            height: bounds.height / 2.5
        )
        
        imageViewModel.loadImage(urlString: product.image, size: imageSize)
        
        imageCancellable = imageViewModel.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard self?.product?.image == product.image else { return }
                self?.productImageView.image = image ?? UIImage(systemName: "photo")
            }
        
        brandNameLabel.text = product.brand
        productNameLabel.text = product.title
        priceLabel.text = "$\(product.price.totalAmount.amount)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageViewModel.cancelLoading()
        imageCancellable?.cancel()
        imageCancellable = nil
        
        product = nil
        productImageView.image = UIImage(systemName: "photo")
        productImageView.tintColor = .systemGray3
    }
}
