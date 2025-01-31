//
//  ProfileViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit

class ProfileViewController: UIViewController {
    let viewModel = DefautlProfileViewModel()
    
    private let header: CustomHeaderView = {
        let header = CustomHeaderView(title: "My Profile", showBackButton: false)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var menuItems = [
        MenuItem(title: "My orders", subtitle: "Already have \(viewModel.numberOfOrders ?? 0) orders", type: .orders),
        MenuItem(title: "Shipping addresses", subtitle: "\(viewModel.numberOfAdresses ?? 0) addresses", type: .shippingAddresses),
        MenuItem(title: "Payment methods", subtitle: "\(viewModel.paymentMethod?.type ?? .unknown)", type: .paymentMethods),
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}

/*
 if let image = UIImage(named: "example") {
     let data = image.jpegData(compressionQuality: 0.8) // 0.0 to 1.0, where 1.0 is highest quality
 }
 */
