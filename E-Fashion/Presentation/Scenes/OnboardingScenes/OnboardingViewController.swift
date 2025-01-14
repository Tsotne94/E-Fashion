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
    }

}
