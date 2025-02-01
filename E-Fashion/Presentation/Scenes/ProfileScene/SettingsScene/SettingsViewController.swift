//
//  SettingsViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    private let viewModel = DefaultSettingsViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemRed.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.opacity = 0.3
        return gradient
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Icons.back)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customWhite
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .customGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        imageView.addGestureRecognizer(tap)
        
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var usernameContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.customWhite.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Username"
        textField.font = UIFont(name: CustomFonts.nutinoMedium, size: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 14)
        button.backgroundColor = .accentRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var settingsTitle: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 17)
        button.backgroundColor = .accentRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(backButton)
        view.addSubview(mainContainerView)
        
        usernameContainer.addSubview(usernameTextField)
        usernameContainer.addSubview(saveButton)
        
        mainContainerView.addSubview(settingsTitle)
        mainContainerView.addSubview(profileImageView)
        mainContainerView.addSubview(editButton)
        mainContainerView.addSubview(emailLabel)
        mainContainerView.addSubview(usernameContainer)
        mainContainerView.addSubview(signOutButton)
        editButton.addTarget(self, action: #selector(handleProfileImageTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            mainContainerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            settingsTitle.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 32),
            settingsTitle.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: settingsTitle.bottomAnchor, constant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            editButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 50),
            editButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            
            emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            emailLabel.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            
            usernameContainer.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
            usernameContainer.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 16),
            usernameContainer.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -16),
            usernameContainer.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextField.leadingAnchor.constraint(equalTo: usernameContainer.leadingAnchor, constant: 16),
            usernameTextField.centerYAnchor.constraint(equalTo: usernameContainer.centerYAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            
            saveButton.trailingAnchor.constraint(equalTo: usernameContainer.trailingAnchor, constant: -8),
            saveButton.centerYAnchor.constraint(equalTo: usernameContainer.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 34),
            
            signOutButton.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -32),
            signOutButton.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -32),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .userInfoFetched:
                    self?.updateUI()
                case .userimageFethced:
                    self?.updateProfileImage()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func updateUI() {
        guard let user = viewModel.user else { return }
        usernameTextField.text = user.displayName
        emailLabel.text = user.email
    }
    
    private func updateProfileImage() {
        if let imageData = viewModel.profilePicture,
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium)
            profileImageView.image = UIImage(systemName: "person.circle.fill", withConfiguration: configuration)?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        }
    }
    
    @objc private func handleBack() {
        viewModel.goBack()
    }
    
    @objc private func handleSave() {
        guard let newUsername = usernameTextField.text, !newUsername.isEmpty else { return }
        viewModel.updateUsername(name: newUsername)
        
        UIView.animate(withDuration: 0.2) {
            self.saveButton.backgroundColor = .systemGreen
            self.saveButton.setTitle("✓", for: .normal)
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.2) {
                    self.saveButton.backgroundColor = .systemBlue
                    self.saveButton.setTitle("Save", for: .normal)
                }
            }
        }
    }
    
    @objc private func handleSignOut() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.viewModel.signOut()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func handleProfileImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        viewModel.updateImage(image: imageData)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
