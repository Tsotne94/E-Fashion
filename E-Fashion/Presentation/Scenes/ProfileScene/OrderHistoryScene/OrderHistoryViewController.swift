//
//  OrderHistoryViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    private lazy var header: CustomHeaderView = {
        let header = CustomHeaderView(title: "My Orders", showBackButton: true)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backButtonTapped = backButtonTapped
        return header
    }()
    
    private let deliveredButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delivered", for: .normal)
        button.backgroundColor = .accentBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let processingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Processing", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let cancelledButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancelled", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var ordersTypeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deliveredButton, processingButton, cancelledButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var ordersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        view.addSubview(header)
        view.addSubview(ordersTypeStackView)
        view.addSubview(ordersTableView)
        setupTableView()
    }
    
    private func setupTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.backgroundColor = .clear
        ordersTableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        ordersTableView.separatorStyle = .none
        ordersTableView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: CustomHeaderView.headerHeight()),
            
            ordersTypeStackView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            ordersTypeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ordersTypeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ordersTypeStackView.heightAnchor.constraint(equalToConstant: 50),
            
            ordersTableView.topAnchor.constraint(equalTo: ordersTypeStackView.bottomAnchor, constant: 20),
            ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ordersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let order = OrderModel(price: 100, deliveryFee: 10, totalPrice: 110, items: [], deliveryProvider: .usps, status: .delivered)
        cell.configureCell(with: order)
        return cell
    }
}

import SwiftUI

struct OrderHistoryPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OrderHistoryViewController {
        return OrderHistoryViewController()
    }
    
    func updateUIViewController(_ uiViewController: OrderHistoryViewController, context: Context) {}
}

#Preview {
    OrderHistoryPreview()
}
