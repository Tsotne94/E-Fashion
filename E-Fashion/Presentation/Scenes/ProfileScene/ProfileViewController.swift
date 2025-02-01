//
//  ProfileViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private var viewModel = DefautlProfileViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private let header: CustomHeaderView = {
        let header = CustomHeaderView(title: "My Profile", showBackButton: false)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private var menuItems: [MenuItem] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private let profileHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        view.backgroundColor = .customWhite
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .customGray
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .customWhite
        
        view.addSubview(header)
        view.addSubview(tableView)
        profileHeaderView.addSubview(profileImageView)
        profileHeaderView.addSubview(nameLabel)
        profileHeaderView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: CustomHeaderView.headerHeight()),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileImageView.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: "ProfileMenuCell")
        tableView.tableHeaderView = profileHeaderView
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .customWhite
        tableView.isScrollEnabled = false
    }
    
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handleViewModelOutput(action)
            }
            .store(in: &subscriptions)
    }
    
    private func handleViewModelOutput(_ action: ProfileViewModelOutputAction) {
        switch action {
        case .profileInfoFetched:
            updateProfileInfo()
        case .profileImageFetched:
            updateProfileImage()
        case .paymentMethodsFetched, .deliveryLcationsFetched:
            updateMenuItems()
        }
    }
    
    private func updateProfileInfo() {
        guard let user = viewModel.user else { return }
        nameLabel.text = (user.displayName)
        emailLabel.text = user.email
    }
    
    private func updateProfileImage() {
        if let imageData = viewModel.profilePicture,
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        }
    }
    
    private func updateMenuItems() {
        menuItems = [
            MenuItem(title: "My orders",
                    subtitle: "Already have \(viewModel.numberOfOrders ?? 0) orders",
                    type: .orders),
            MenuItem(title: "Shipping addresses",
                    subtitle: "\(viewModel.numberOfAdresses ?? 0) addresses",
                    type: .shippingAddresses),
            MenuItem(title: "Payment methods",
                     subtitle: viewModel.paymentMethod?.number.identifyCardType().getImageName() ?? "No payment method",
                    type: .paymentMethods),
            MenuItem(title: "Settings",
                    subtitle: "Username, Logout",
                    type: .settings)
        ]
        tableView.reloadData()
    }
    
    private func handleMenuItemTap(_ type: MenuItemType) {
        switch type {
        case .orders:
            print("orders tapped")
        case .shippingAddresses:
            viewModel.goToAddresses()
        case .paymentMethods:
            viewModel.goToPaymentMethods()
        case .settings:
            viewModel.goToSettings()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath) as! ProfileMenuCell
        let menuItem = menuItems[indexPath.row]
        cell.configure(with: menuItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuItem = menuItems[indexPath.row]
        handleMenuItemTap(menuItem.type)
    }
}
