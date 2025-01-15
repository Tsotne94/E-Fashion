//
//  OnboardingViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var doneRequested: () -> Void

    init(doneRequested: @escaping () -> Void) {
        self.doneRequested = doneRequested
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func doneButtonTapped() {
        print("Done button tapped. Calling doneRequested closure.")
        doneRequested()
    }

}
