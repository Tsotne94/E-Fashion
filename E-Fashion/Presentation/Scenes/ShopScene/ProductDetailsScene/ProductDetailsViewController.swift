//
//  ProductDetailsViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 27.01.25.
//

import UIKit
import Combine
import Lottie

class ProductDetailsViewController: UIViewController {
    private let productId: Int
    private let viewModel = DefaultProductDetailsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    let backButtonAction: () -> ()
    
    private lazy var headerView: CustomHeaderView = {
        let header = CustomHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15)
        ])
        
        return header
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Icons.share), for: .normal)
        return button
    }()
    
    private lazy var sizeLabel: UILabel = createPaddedLabel()
    private lazy var colorLabel: UILabel = createPaddedLabel()
    
    private lazy var favouritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Icons.heart), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        return button
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 15)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoMedium, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var longDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .accentRed
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageUICollectionViewCell.self, forCellWithReuseIdentifier: ImageUICollectionViewCell.reuseIdentifier)
        collection.addShadow()
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .systemBlue
        control.pageIndicatorTintColor = .systemGray4
        control.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var loadingIndicator: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loader")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        animation.isHidden = true
        return animation
    }()
    
    init(id: Int, backButtonAction: @escaping () -> ()) {
        self.productId = id
        self.backButtonAction = backButtonAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .customWhite
        headerView.backButtonTapped = { [weak self] in self?.backButtonTapped() }
        setupUI()
        setupBinding()
        setupActions()
        
        viewModel.viewDidLoad(productId: productId)
    }
    
    private func setupBinding() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .infoFetched:
                    self?.updateProductInfo()
                case .imagesFetched:
                    self?.collectionView.reloadData()
                case .addedToCart:
                    self?.showToast(message: "Added to cart successfully")
                case .isLoading(let isLoading):
                    self?.updateLoadingState(isLoading)
                case .failedToAddInCart:
                    self?.showAlert(title: "Error", message: "Failed to add item to cart")
                case .failedToAddInFavourites:
                    self?.showAlert(title: "Error", message: "Failed to add item to favourites")
                default: break
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$inCart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAddToCartButton()
            }
            .store(in: &subscriptions)
        
        viewModel.$isFavourite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFavouriteButton()
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        
        view.addSubview(headerView)
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        
        [collectionView, pageControl, brandLabel, priceLabel, favouritesButton,
         descriptionLabel, sizeLabel, colorLabel, longDescriptionLabel, addToCartButton].forEach {
            contentView.addSubview($0)
        }
        
        let standardSpacing: CGFloat = 16
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: CustomHeaderView.headerHeight()),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 100),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            sizeLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: standardSpacing),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            sizeLabel.heightAnchor.constraint(equalToConstant: 36),
            sizeLabel.widthAnchor.constraint(equalToConstant: 120),
            
            colorLabel.topAnchor.constraint(equalTo: sizeLabel.topAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: sizeLabel.trailingAnchor, constant: standardSpacing),
            colorLabel.heightAnchor.constraint(equalToConstant: 36),
            colorLabel.widthAnchor.constraint(equalToConstant: 120),
            
            favouritesButton.topAnchor.constraint(equalTo: sizeLabel.topAnchor),
            favouritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            favouritesButton.widthAnchor.constraint(equalToConstant: 40),
            favouritesButton.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.topAnchor.constraint(equalTo: favouritesButton.bottomAnchor, constant: standardSpacing),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            
            descriptionLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: standardSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -standardSpacing),
            
            longDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: standardSpacing),
            longDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            longDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            
            addToCartButton.topAnchor.constraint(equalTo: longDescriptionLabel.bottomAnchor, constant: standardSpacing * 1.5),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardSpacing * 1.5)
        ])
    }
    
    private func setupActions() {
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouritesTapped), for: .touchUpInside)
    }
    
    private func createPaddedLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 14)
        label.backgroundColor = .accentBlack
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        
        label.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }
    
    private func updateProductInfo() {
        guard let product = viewModel.product else { return }
        
        headerView.setTitle(product.brand.name ?? "")
        brandLabel.text = product.brand.name
        priceLabel.text = "$\(product.price.totalAmount)"
        descriptionLabel.text = product.title
        longDescriptionLabel.text = product.description
        sizeLabel.text = "Size: \(product.size?.name ?? "")"
        colorLabel.text = "Color: \(product.color?.name ?? "")"
        
        pageControl.numberOfPages = product.images.count > 3 ? 3 : product.images.count
    }
    
    private func updateFavouriteButton() {
        let image = viewModel.isFavourite ? UIImage(named: Icons.smallRedHeart) : UIImage(named: Icons.heart)
        favouritesButton.setImage(image, for: .normal)
    }
    
    private func updateAddToCartButton() {
        if viewModel.inCart {
            addToCartButton.setTitle("In Cart", for: .normal)
            addToCartButton.backgroundColor = .customGray
            addToCartButton.isEnabled = false
        } else {
            addToCartButton.setTitle("Add to Cart", for: .normal)
            addToCartButton.backgroundColor = .accentRed
            addToCartButton.isEnabled = true
        }
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.isHidden = false
            loadingIndicator.play()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stop()
        }
    }
    
    func backButtonTapped() {
        backButtonAction()
    }
    
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func favouritesTapped() {
        if viewModel.isFavourite {
            viewModel.removeFromFavourites()
        } else {
            viewModel.addToFavourites()
        }
    }
    
    @objc private func shareTapped() {
        viewModel.shareButtonTapped()
    }
    
    @objc private func addToCartTapped() {
        viewModel.addToCart()
    }
}


extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageUICollectionViewCell.reuseIdentifier, for: indexPath) as? ImageUICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageData = viewModel.images[indexPath.item]
        cell.configure(with: imageData)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
