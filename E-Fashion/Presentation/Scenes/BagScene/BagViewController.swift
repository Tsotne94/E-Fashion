//
//  BagViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit
import Combine

class BagViewController: UIViewController {
    var infoLabel: UILabel?
    var viewModel: FirstTabViewModel!
    var showDetailRequested: () -> Void = { }
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$nname
            .sink { newValue in
                print("nname updated in controller: \(newValue)")
            }
            .store(in: &subscriptions)
        
        
        view.backgroundColor = .purple
        
        setupInfoLabel()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        infoLabel?.text = viewModel.nname
    }
    
    func setupButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 60))
        
        button.setTitleColor(.accentRed, for: .normal)
        button.setTitle("pressss hereee", for: .normal)
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func setupInfoLabel() {
        let infoLabel = UILabel(frame: CGRect(x: 100, y: 300, width: 300, height: 60))
        self.view.addSubview(infoLabel)
        self.infoLabel = infoLabel
    }
    
    @objc func tapped() {
        showDetailRequested()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
