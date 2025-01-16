//
//  DemoViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.01.25.
//
import UIKit

class DemoViewController: UIViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    
    let imageName: String
    let titleText: String
    let descriptionText: String
    
    init(imageName: String, titleText: String, pageDescription: String) {
        self.imageName = imageName
        self.titleText = titleText
        self.descriptionText = pageDescription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        setupImage()
        setupTitle()
        setupDescription()
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let image = UIImage(named: imageName)
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.21)
        ])
        
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: CustomFonts.nutinoBold, size: 24)
        titleLabel.textColor = .accentBlack
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.text = descriptionText
        descriptionLabel.font = UIFont(name: CustomFonts.nutinoMedium, size: 14)
        descriptionLabel.textColor = .customGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}



