//
//  SortMenuViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import UIKit

class SortMenuViewController: UIViewController {
    let viewModel: DefaultProductsCatalogViewModel
    let nowSelected: OrderType
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort by"
        label.font = UIFont(name: CustomFonts.nutinoBlack, size: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttons: [UIButton] = {
        return OrderType.allCases.map { orderType in
            var config = UIButton.Configuration.plain()
            
            if orderType == nowSelected {
                config.baseForegroundColor = .white
                config.background.backgroundColor = .accentRed
            } else {
                config.baseForegroundColor = .accentBlack
                config.background.backgroundColor = .clear
            }
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            
            let button = UIButton(configuration: config)
            button.setTitle(orderType.rawValue, for: .normal)
            button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
            button.contentHorizontalAlignment = .left
            button.tag = orderType.hashValue
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    init(selected: OrderType, viewModel: DefaultProductsCatalogViewModel) {
        self.nowSelected = selected
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        
        let separator = createSeparator()
        stackView.addArrangedSubview(separator)
        
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let selectedOrderType = OrderType.allCases.first(where: { $0.hashValue == sender.tag }) else { return }
        viewModel.orederType = selectedOrderType
        viewModel.dismissPresented()
    }
}
