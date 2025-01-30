//
//  ProductSectionTableCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

import Combine
import UIKit
import Lottie

class ProductSectionTableCell: UITableViewCell, IdentifiableProtocol {
    private let viewModel = DefaultHomeViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private let loaderView: LottieAnimationView = {
        let loader = LottieAnimationView(name: "loader")
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.loopMode = .loop
        loader.contentMode = .scaleAspectFit
        loader.isHidden = true
        return loader
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoBlack, size: 34)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customGray
        label.font = UIFont(name: CustomFonts.nutinoLight, size: 11)
        return label
    }()
    
    private let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View all", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoRegular, size: 11)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 260)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    private var items: HomePageItems = .new
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .customWhite
        self.selectionStyle = .none
        setupBindings()
        setupViews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .productsFetched:
                    self?.collectionView.reloadData()
                case .showError(let error):
                    print("error while loading products error: \(error)")
                case .isLoading(let isLoading):
                    if isLoading {
                        self?.loaderView.stop()
                        self?.loaderView.isHidden = true
                    } else {
                        self?.loaderView.stop()
                        self?.loaderView.isHidden = true
                    }
                }
            }.store(in: &subscriptions)
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(viewAllButton)
        contentView.addSubview(collectionView)
        contentView.addSubview(loaderView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            viewAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loaderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.reuseIdentifier)
    }
    
    func configure(title: String, subtitle: String, items: HomePageItems) {
        self.items = items
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        loaderView.isHidden = false
        loaderView.play()
        
        viewModel.fetchFavourites()
        switch self.items {
        case .new:
            viewModel.fetchNew()
        case .hot:
            viewModel.fetchHot()
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ProductSectionTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch items {
        case .new:
            return self.viewModel.newItems.count
        case .hot:
            return self.viewModel.hotItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.reuseIdentifier, for: indexPath) as! ProductCollectionCell
        
        switch items {
        case .new:
            cell.configureCell(with: viewModel.newItems[indexPath.row])
            return cell
        case .hot:
            cell.configureCell(with: viewModel.hotItems[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items {
        case .new:
            let id = viewModel.newItems[indexPath.row].productId
            viewModel.productTapped(productId: id)
        case .hot:
            let id = viewModel.hotItems[indexPath.row].productId
            viewModel.productTapped(productId: id)
        }
    }
}
