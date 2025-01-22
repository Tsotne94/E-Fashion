//
//  BannerTableCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

import UIKit

class BannerTableCell: UITableViewCell, IdentifiableProtocol {
    private let bannerView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Icons.banner)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Street Clothes"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.nutinoBlack, size: 34)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBanner()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBanner() {
        contentView.addSubview(containerView)
        containerView.addSubview(bannerView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            bannerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            bannerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20)
            
        ])
    }
}
