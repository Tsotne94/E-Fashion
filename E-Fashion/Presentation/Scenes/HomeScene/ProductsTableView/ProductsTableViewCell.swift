//
//  ProductsTableViewCell.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import UIKit

class ProductsTableViewCell: UITableViewCell, IdentifiableProtocol {
    let productType: HomePageItems
    
    init(productType: HomePageItems) {
        self.productType = productType
        super.init(style: .default, reuseIdentifier: ProductsTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
