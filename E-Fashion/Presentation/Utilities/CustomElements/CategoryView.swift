//
//  CategoryUIView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//

import UIKit

class CategoryView: UIView {
   let title: String
   let image: UIImage?
   
   private let imageView: UIImageView = {
       let view = UIImageView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.contentMode = .scaleAspectFill
       view.clipsToBounds = true
       return view
   }()
   
   private let titleLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = .systemFont(ofSize: 24, weight: .bold)
       label.textColor = .white
       return label
   }()
   
   private let overlayView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
       return view
   }()
   
   init(title: String, image: UIImage?, frame: CGRect = .zero) {
       self.title = title
       self.image = image
       super.init(frame: frame)
       setupUI()
   }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        clipsToBounds = true  
        
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 20
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        
       addSubview(imageView)
       addSubview(overlayView)
       addSubview(titleLabel)
       
       titleLabel.text = title
       imageView.image = image
       
       NSLayoutConstraint.activate([
           imageView.topAnchor.constraint(equalTo: topAnchor),
           imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
           imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
           imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
           
           overlayView.topAnchor.constraint(equalTo: topAnchor),
           overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
           overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
           overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
           
           titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
       ])
   }
   
   func setImage(_ image: UIImage?) {
       imageView.image = image
   }
}
