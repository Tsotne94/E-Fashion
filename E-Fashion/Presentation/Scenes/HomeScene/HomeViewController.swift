//
//  HomeViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Combine
import UIKit

class HomeViewController: UIViewController {
    private let productsTableView = ProductsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .customWhite
    }

}
