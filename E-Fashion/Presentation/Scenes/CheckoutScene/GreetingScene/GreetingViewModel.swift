//
//  GreetingViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine
import Foundation

protocol GreetingViewModel: GreetingViewModelInput, GreetingViewModelOutput {
}

protocol GreetingViewModelInput {
    func viewDidLoad()
}

protocol GreetingViewModelOutput{
    
}

final class DefaultGreetingViewModelOutput: GreetingViewModel {
    @Inject private var clearCartUseCase: ClearCartUseCase
    
    private var subscriptions = Set<AnyCancellable>()
    
    func viewDidLoad() {
        clearCartUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("succsessfully cleared cart")
                case .failure(let error):
                    print("there war error claring cart error: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                print("succsessfully cleared cart")
            }.store(in: &subscriptions)
    }
}
