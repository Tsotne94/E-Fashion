//
//  HomeViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Combine
import UIKit

class HomeViewController: UIViewController {
    private enum Section: Int, CaseIterable {
         case banner = 0
         case hot
         case new
     }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        setupTableView()
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BannerTableCell.self, forCellReuseIdentifier: BannerTableCell.reuseIdentifier)
        tableView.register(ProductSectionTableCell.self, forCellReuseIdentifier: ProductSectionTableCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.row) {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableCell.reuseIdentifier, for: indexPath) as! BannerTableCell
            return cell
            
        case .hot:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductSectionTableCell.reuseIdentifier, for: indexPath) as! ProductSectionTableCell
            cell.configure(
                title: "Hot",
                subtitle: "What's making waves today",
                items: .hot
            )
            return cell
            
        case .new:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductSectionTableCell.reuseIdentifier, for: indexPath) as! ProductSectionTableCell
            cell.configure(
                title: "New",
                subtitle: "You've never seen it before!",
                items: .new
            )
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.row) {
        case .banner:
            return 200
        case .hot, .new:
            return 350
        default:
            return 0
        }
    }
}
