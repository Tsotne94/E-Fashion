//
//  ProductsCatalogViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 25.01.25.
//

import Combine
import UIKit
import Lottie

class ProductsCatalogViewController: UIViewController {
    private let viewModel = DefaultProductsCatalogViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var isWideLayout = false
    
    private var productCellWidth: CGFloat {
        return isWideLayout ? view.bounds.width / 1.2 : view.bounds.width / 2.4
    }
    
    private var productCellHeight: CGFloat {
        return isWideLayout ? productCellWidth * 1.3 : productCellWidth * 1.55
    }
    
    private let headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.setTitle("Category name here")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: Icons.search), for: .normal)
        return button
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = .init(width: 50, height: 50)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [filterButton, sortButton, layoutButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.addShadow()
        stackView.backgroundColor = .customGray.withAlphaComponent(0.3)
        stackView.layer.cornerRadius = 15
        return stackView
    }()
    
    private let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 8
        let button = UIButton(configuration: config)
        button.setImage(UIImage(named: Icons.filter), for: .normal)
        button.setTitle("Filters", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        return button
    }()
    
    private lazy var sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 8
        let button = UIButton(configuration: config)
        button.setImage(UIImage(named: Icons.sort), for: .normal)
        button.setTitle("\(viewModel.sortLabel)", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        return button
    }()
    
    private let layoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 8
        let button = UIButton(configuration: config)
        button.setImage(UIImage(named: Icons.singleColumn), for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: productCellWidth, height: productCellHeight)
        layout.estimatedItemSize = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = true
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingIndicator: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loader")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        animation.isHidden = true
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        setupConstraints()
        setupTargets()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        
        view.addSubview(headerView)
        headerView.addSubview(searchButton)
        view.addSubview(categoriesCollectionView)
        view.addSubview(buttonStackView)
        view.addSubview(productsCollectionView)
        
        view.addSubview(blurView)
        view.addSubview(loadingIndicator)
        
        setupCategoriesCollectionView()
        setupProductsCollectionView()
        
        headerView.backButtonTapped = { [weak self] in
            self?.viewModel.backButtonTapped()
        }
    }
    
    private func setupBinding() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .productsFetched:
                    self?.productsCollectionView.reloadData()
                case .sortingChanged:
                    self?.productsCollectionView.reloadData()
                    self?.sortButton.setTitle(self?.viewModel.sortLabel, for: .normal)
                case .isLoading(let isLoading):
                    self?.updateLoadingState(isLoading)
                }
            }.store(in: &subscriptions)
    }
    
    private func setupCategoriesCollectionView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.reuseIdentifier)
    }
    
    private func setupProductsCollectionView() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: CustomHeaderView.headerHeight()),
            
            searchButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 35),
            
            buttonStackView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 8),
            buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            productsCollectionView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 8),
            productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 100),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupTargets() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        layoutButton.addTarget(self, action: #selector(layoutButtonTapped), for: .touchUpInside)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            blurView.isHidden = false
            loadingIndicator.isHidden = false
            loadingIndicator.play()
        } else {
            blurView.isHidden = true
            loadingIndicator.isHidden = true
            loadingIndicator.stop()
        }
    }
    
    @objc private func searchButtonTapped() {
        print("Search button tapped")
    }
    
    @objc private func filterButtonTapped() {
        viewModel.presentFilterView()
    }
    
    @objc private func sortButtonTapped() {
        viewModel.presentSortingView()
    }
    
    @objc private func layoutButtonTapped() {
        isWideLayout.toggle()
        
        if let layout = productsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: productCellWidth, height: productCellHeight)
        }
        
        let imageName = isWideLayout ? Icons.dualColumn : Icons.singleColumn
        layoutButton.setImage(UIImage(named: imageName), for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.productsCollectionView.performBatchUpdates(nil)
        }
    }
}

extension ProductsCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return viewModel.cateogries.count
        } else {
            return viewModel.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            cell.configureCell(with: viewModel.cateogries[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.reuseIdentifier, for: indexPath) as! ProductCollectionCell
            cell.configureCell(with: viewModel.products[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            
        } else {
            let id = viewModel.products[indexPath.row].productId
            viewModel.productTappedAt(index: id)
        }
    }
}

