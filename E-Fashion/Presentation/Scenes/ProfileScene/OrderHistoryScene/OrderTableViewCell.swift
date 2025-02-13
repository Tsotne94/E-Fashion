//
//  OrderTableViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

import UIKit

class OrderTableViewCell: UITableViewCell, IdentifiableProtocol {
    private var order: OrderModel?
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentBlack
        label.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoRegular, size: 16)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private let detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nutinoMedium, size: 16)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(orderNumberLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(detailsButton)
        contentView.addSubview(statusLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            orderNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            orderNumberLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            dateLabel.centerYAnchor.constraint(equalTo: orderNumberLabel.centerYAnchor),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            quantityLabel.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 20),
            quantityLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            
            detailsButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            detailsButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 25),
            detailsButton.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 4),
            detailsButton.heightAnchor.constraint(equalToConstant: 50),
            detailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            statusLabel.centerYAnchor.constraint(equalTo: detailsButton.centerYAnchor),
        ])
    }
    
    @objc private func detailsTapped() {
        guard let order = order else { return }
        print(order.deliveryProvider)
    }
    
    func configureCell(with order: OrderModel) {
        self.order = order
        orderNumberLabel.text = String(order.id.prefix(10))
        
        let number = "Quantity: \(order.items.count)"
        let length = number.count - 10
        let attributedNum = NSMutableAttributedString(string: number)
        attributedNum.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 10, length: length))
        quantityLabel.text = attributedNum.string
        
        let date = order.timeStamp.formatted(date: .numeric, time: .omitted)
        dateLabel.text = date
        
        let total = "Total Amount: \(order.totalPrice)$"
        let pricelength = total.count - 14
        let attrPrice = NSMutableAttributedString(string: total)
        attrPrice.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 14, length: pricelength))
        priceLabel.text = String(order.totalPrice)
        
        statusLabel.text = order.status.name
        switch order.status {
        case .delivered:
            self.statusLabel.textColor = .green
        case .cancelled:
            self.statusLabel.textColor = .accentRed
        case .proccessing:
            self.statusLabel.textColor = .accentBlack
        }
    }
}
