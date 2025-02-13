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
//        header.backButtonTapped =
        return header
    }()
    
    private let deliveredButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delivered", for: .normal)
        button.backgroundColor = .accentBlack
        button.setTitleColor(.white, for: .normal)
        button.configuration?.titlePadding = 10
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let proccessingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proccessing", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.configuration?.titlePadding = 10
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let cancelledButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Canncelled", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.configuration?.titlePadding = 10
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var ordersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
