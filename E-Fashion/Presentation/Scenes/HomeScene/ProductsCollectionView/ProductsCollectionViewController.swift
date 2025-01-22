//
//  ProductsCollectionViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import UIKit

class ProductsCollectionViewController: UICollectionViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier, for: indexPath)
    
    
        return cell
    }

}
