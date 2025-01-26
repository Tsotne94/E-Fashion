//
//  ShopViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//

import Combine
import Foundation

protocol ShopViewModel: ShopViewModelInput, ShopViewModelOutput {
}

protocol ShopViewModelInput {
    func goToCategory(id: Int)
    var currentCategory: CategoryType { get set }
}

protocol ShopViewModelOutput {
    var output: AnyPublisher<ShopViewModelOutputAction, Never> { get }
}

enum ShopViewModelOutputAction {
    case updateImages(CategoryType)
}

final class DefaultShopViewModel: ShopViewModel {
    @Inject private var shopCoordinator: ShopTabCoordinator
    
    var currentCategory: CategoryType = .women {
        didSet {
            _output.send(.updateImages(currentCategory))
        }
    }
    
    private var _output = PassthroughSubject<ShopViewModelOutputAction, Never>()
    var output: AnyPublisher<ShopViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    func goToCategory(id: Int) {
        shopCoordinator.goToProducts(id: id)
    }
}
