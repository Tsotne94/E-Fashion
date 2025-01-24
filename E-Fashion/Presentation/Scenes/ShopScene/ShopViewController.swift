//
//  ShopViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit
import Combine

class ShopViewController: UIViewController {
    private var viewModel = DefaultShopViewModel()
    
    private var highlightCenterXConstraint: NSLayoutConstraint?
    private var highlightWidthConstraint: NSLayoutConstraint?
    
    private lazy var categoryHeight: CGFloat = view.bounds.height / 7
    private lazy var headerHeight: CGFloat = {
       return UIScreen.main.bounds.height > 667 ? 100 : 60
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Categories"
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        label.textColor = .accentBlack
        label.textAlignment = .center
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
    
    private let womanButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Woman", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        return button
    }()
    
    private let manButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Men", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        return button
    }()
    
    private let kidButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kid", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        return button
    }()
    
    private let highlightView: UIView = {
        let redLine = UIView()
        redLine.backgroundColor = .red
        redLine.translatesAutoresizingMaskIntoConstraints = false
        redLine.backgroundColor = .accentRed
        return redLine
    }()
    
    private let categoryNew: CategoryView = {
        let view = CategoryView(title: "New", image: UIImage(named: WomenAssets.new))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()
    
    private let categoryClothes: CategoryView = {
        let view = CategoryView(title: "Clothes", image: UIImage(named: WomenAssets.clothes))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()
    
    private let categoryShoes: CategoryView = {
        let view = CategoryView(title: "Shoes", image: UIImage(named: WomenAssets.shoes))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()
    
    private let categoryAcceories: CategoryView = {
        let view = CategoryView(title: "Accessories", image: UIImage(named: WomenAssets.accessories))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addShadow()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .customWhite
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(womanButton)
        view.addSubview(manButton)
        view.addSubview(kidButton)
        view.addSubview(highlightView)
        view.addSubview(categoryNew)
        view.addSubview(categoryClothes)
        view.addSubview(categoryShoes)
        view.addSubview(categoryAcceories)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            womanButton.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            womanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            manButton.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            manButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            kidButton.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            kidButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            highlightView.heightAnchor.constraint(equalToConstant: 2),
            highlightView.topAnchor.constraint(equalTo: womanButton.bottomAnchor, constant: 5),
            
            categoryNew.topAnchor.constraint(equalTo: womanButton.bottomAnchor, constant: 30),
            categoryNew.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryNew.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryNew.heightAnchor.constraint(equalToConstant: categoryHeight),
            
            categoryClothes.topAnchor.constraint(equalTo: categoryNew.bottomAnchor, constant: 20),
            categoryClothes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryClothes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryClothes.heightAnchor.constraint(equalToConstant: categoryHeight),
            
            categoryShoes.topAnchor.constraint(equalTo: categoryClothes.bottomAnchor, constant: 20),
            categoryShoes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryShoes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryShoes.heightAnchor.constraint(equalToConstant: categoryHeight),
            
            categoryAcceories.topAnchor.constraint(equalTo: categoryShoes.bottomAnchor, constant: 20),
            categoryAcceories.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryAcceories.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryAcceories.heightAnchor.constraint(equalToConstant: categoryHeight)
        ])
        
        highlightCenterXConstraint = highlightView.centerXAnchor.constraint(equalTo: womanButton.centerXAnchor)
        highlightWidthConstraint = highlightView.widthAnchor.constraint(equalTo: womanButton.widthAnchor)
        highlightCenterXConstraint?.isActive = true
        highlightWidthConstraint?.isActive = true
    }
    
    private func setupBindings() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .updateImages(let category):
                    self?.updateCategoryImages(for: category)
                }
            }
            .store(in: &subscriptions)
        
        womanButton.addTarget(self, action: #selector(womanCategoryTapped), for: .touchUpInside)
        manButton.addTarget(self, action: #selector(menCategoryTapped), for: .touchUpInside)
        kidButton.addTarget(self, action: #selector(kidCategoryTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func updateCategoryImages(for category: CategoryType) {
        switch category {
        case .women:
            categoryNew.setImage(UIImage(named: WomenAssets.new))
            categoryClothes.setImage(UIImage(named: WomenAssets.clothes))
            categoryShoes.setImage(UIImage(named: WomenAssets.shoes))
            categoryAcceories.setImage(UIImage(named: WomenAssets.accessories))
        case .men:
            categoryNew.setImage(UIImage(named: MenAssets.new))
            categoryClothes.setImage(UIImage(named: MenAssets.clothes))
            categoryShoes.setImage(UIImage(named: MenAssets.shoes))
            categoryAcceories.setImage(UIImage(named: MenAssets.accessories))
        case .kids:
            categoryNew.setImage(UIImage(named: KidsAssets.new))
            categoryClothes.setImage(UIImage(named: KidsAssets.clothes))
            categoryShoes.setImage(UIImage(named: KidsAssets.shoes))
            categoryAcceories.setImage(UIImage(named: KidsAssets.accessories))
        }
    }
    
    private func updateHighlightPosition(for button: UIButton) {
        highlightCenterXConstraint?.isActive = false
        highlightWidthConstraint?.isActive = false
        
        highlightCenterXConstraint = highlightView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        highlightWidthConstraint = highlightView.widthAnchor.constraint(equalTo: button.widthAnchor)
        
        highlightCenterXConstraint?.isActive = true
        highlightWidthConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func womanCategoryTapped() {
        viewModel.currentCategory = .women
        updateHighlightPosition(for: womanButton)
    }
    
    @objc private func menCategoryTapped() {
        viewModel.currentCategory = .men
        updateHighlightPosition(for: manButton)
    }
    
    @objc private func kidCategoryTapped() {
        viewModel.currentCategory = .kids
        updateHighlightPosition(for: kidButton)
    }
    
    @objc private func backButtonTapped() {
        
    }
}
