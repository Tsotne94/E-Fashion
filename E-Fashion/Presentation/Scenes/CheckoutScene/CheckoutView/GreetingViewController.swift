//
//  GreetingViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import UIKit

class GreetingViewController: UIViewController {
    @Inject private var mainCoordinator: BagTabCoordinator
    
    private let greetingImage: UIImageView = {
        let image = UIImage(named: Icons.successfulPurchase)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Success"
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 30)
        label.textAlignment = .center
        
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your order will be delivered soon. Thank you for choosing our app!"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private let continueShoppingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONTINUE SHOPPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        button.backgroundColor = .accentRed
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        view.addSubview(greetingImage)
        view.addSubview(successLabel)
        view.addSubview(infoLabel)
        view.addSubview(continueShoppingButton)
        
        continueShoppingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        mainCoordinator.popToRoot()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            continueShoppingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            continueShoppingButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            continueShoppingButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            continueShoppingButton.heightAnchor.constraint(equalToConstant: 50),
            
            greetingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            greetingImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            greetingImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            successLabel.topAnchor.constraint(equalTo: greetingImage.bottomAnchor, constant: 40),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 8),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

}
