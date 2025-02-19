//
//  OrderHistoryViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

import Combine
import UIKit

class OrderHistoryViewController: UIViewController {
    private let viewModel = DefaultOrderHistoryViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
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
        setupBinding()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        view.addSubview(header)
        view.addSubview(ordersTypeStackView)
        view.addSubview(ordersTableView)
        setupTableView()
        
        deliveredButton.addTarget(self, action: #selector(deliveredTapped), for: .touchUpInside)
        processingButton.addTarget(self, action: #selector(proccessingTapped), for: .touchUpInside)
        cancelledButton.addTarget(self, action: #selector(cancelledTapped), for: .touchUpInside)
    }
    
    private func setupBinding() {
        viewModel.output
            .sink { [weak self] action in
                switch action {
                case .ordersFetched:
                    self?.ordersTableView.reloadData()
                case .statusChanged(let orderStatus):
                    self?.highlightButton(orderStatus)
                }
            }.store(in: &subscriptions)
    }
    
    private func setupTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.backgroundColor = .clear
        ordersTableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        ordersTableView.separatorStyle = .none
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
            ordersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func deliveredTapped() {
        viewModel.fetchedOrdersStatus = .delivered
    }
    
    @objc private func proccessingTapped() {
        viewModel.fetchedOrdersStatus = .proccessing
    }
    
    @objc private func cancelledTapped() {
        viewModel.fetchedOrdersStatus = .cancelled
    }
    
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func highlightButton(_ sender: OrderStatus) {
        switch sender {
        case .delivered:
            highlight(deliveredButton)
            resetButton(processingButton)
            resetButton(cancelledButton)
        case .proccessing:
            highlight(processingButton)
            resetButton(deliveredButton)
            resetButton(cancelledButton)
        case .cancelled:
            highlight(cancelledButton)
            resetButton(processingButton)
            resetButton(deliveredButton)
        }
    }
    
    private func highlight(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = .accentBlack
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    private func resetButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = .lightGray
            sender.setTitleColor(.accentBlack, for: .normal)
        }
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let order = viewModel.orders[indexPath.row]
        cell.configureCell(with: order)
        cell.addShadow()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
