//
//  ProfileViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit

protocol ProfileNavigationDelegate: AnyObject {
    func didSelectOrders()
    func didSelectShippingAddresses()
    func didSelectPaymentMethods()
    func didSelectPromocodes()
    func didSelectSettings()
}

class ProfileViewController: UIViewController {
    struct MenuItem {
        let title: String
        let subtitle: String
        let type: MenuItemType
    }
    
    enum MenuItemType {
        case orders
        case shippingAddresses
        case paymentMethods
        case promocodes
        case settings
    }
    
    weak var navigationDelegate: ProfileNavigationDelegate?
    
    private let header: CustomHeaderView = {
        let header = CustomHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.setTitle("My Profile")
        return header
    }()
    
    private let menuItems = [
        MenuItem(title: "My orders", subtitle: "Already have 12 orders", type: .orders),
        MenuItem(title: "Shipping addresses", subtitle: "3 addresses", type: .shippingAddresses),
        MenuItem(title: "Payment methods", subtitle: "Visa **34", type: .paymentMethods),
        MenuItem(title: "Promocodes", subtitle: "You have special promocodes", type: .promocodes),
        MenuItem(title: "Settings", subtitle: "Notifications, password", type: .settings)
    ]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private let profileHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Matilda Brown"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "matildabrown@mail.com"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        setupGestures()
    }

    private func setupUI() {
        self.title = "My Profile"
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
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    

    @objc private func profileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func handleMenuItemTap(_ type: MenuItemType) {
        switch type {
        case .orders:
            navigationDelegate?.didSelectOrders()
        case .shippingAddresses:
            navigationDelegate?.didSelectShippingAddresses()
        case .paymentMethods:
            navigationDelegate?.didSelectPaymentMethods()
        case .promocodes:
            navigationDelegate?.didSelectPromocodes()
        case .settings:
            navigationDelegate?.didSelectSettings()
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}

class ProfileMenuCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        accessoryType = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 13),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with menuItem: ProfileViewController.MenuItem) {
        titleLabel.text = menuItem.title
        subtitleLabel.text = menuItem.subtitle
    }
}

import SwiftUI

struct GreetingViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ProfileViewController {
        return ProfileViewController()
    }
    
    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
        
    }
}

#Preview {
    GreetingViewControllerPreview()
}
