//
//  ProfileViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import Combine
import Foundation

protocol ProfileViewModel: ProfileViewModelInput, ProfileViewModelOutput {
}

protocol ProfileViewModelInput {
    func viewDidLoad()
    func fetchUserInfo()
    func loadUserImage()
    func goToAddresses()
    func goToPaymentMethods()
    func goToSettings()
    func goToOrders()
    var user: User? { get }
    var numberOfOrders: Int? { get }
    var numberOfAdresses: Int? { get }
    var paymentMethod: CardModel? { get }
    var profilePicture: Data? { get }
}

protocol ProfileViewModelOutput {
    var output: AnyPublisher<ProfileViewModelOutputAction, Never> { get }
}

enum ProfileViewModelOutputAction {
    case profileInfoFetched
    case profileImageFetched
    case paymentMethodsFetched
    case deliveryLcationsFetched
}

final class DefautlProfileViewModel: ProfileViewModel {
    @Inject private var profileCoordinator: ProfileTabCoordinator
    
    @Inject private var fetchUserInfoUseCase: FetchUserInfoUseCase
    @Inject private var fetchImageUseCase: FetchImageUseCase
    @Inject private var fetchAdressesUseCase: FetchDeliveryAddressUseCase
    @Inject private var fetchPaymentMethdsUseCase: FetchPaymentMethodsUseCase
    
    private var _output = PassthroughSubject<ProfileViewModelOutputAction, Never>()
    var output: AnyPublisher<ProfileViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var user: User? = nil
    var numberOfOrders: Int? = 5
    var numberOfAdresses: Int? = nil
    var paymentMethod: CardModel? = nil
    var profilePicture: Data? = nil
    
    func viewDidLoad() {
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        fetchUserInfoUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched user info")
                case .failure(let error):
                    print("error occured during fethcing user info, error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.loadUserImage()
                self?._output.send(.profileInfoFetched)
            }.store(in: &subscriptions)

        fetchAddresses()
        fetchPaymentMethods()
    }
    
    private func fetchAddresses() {
        fetchAdressesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched addresses")
                case .failure(let error):
                    print("error occured during fetching addresses, error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] addresses in
                self?.numberOfAdresses = addresses.count
                self?._output.send(.deliveryLcationsFetched)
            }.store(in: &subscriptions)
    }
    
    private func fetchPaymentMethods() {
        fetchPaymentMethdsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched payment methods")
                case .failure(let error):
                    print("error occured during fetching payment methods, error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] cards in
                self?.paymentMethod = cards.first
                self?._output.send(.paymentMethodsFetched)
            }.store(in: &subscriptions)
    }
    
    func loadUserImage() {
        if let user {
            guard let image = user.imageUrl else { return }
            fetchImageUseCase.execute(urlString: image)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("successfully loaded user image")
                    case .failure(let error):
                        print("error occured during loading user image, error: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] data in
                    self?.profilePicture = data
                    self?._output.send(.profileImageFetched)
                }.store(in: &subscriptions)
        }
    }
    
    func goToAddresses() {
        profileCoordinator.goToAddresses()
    }
    
    func goToPaymentMethods() {
        profileCoordinator.goToPaymentMethods()
    }
    
    func goToSettings() {
        profileCoordinator.goToSettings()
    }
    
    func goToOrders() {
        profileCoordinator.goToOrderHistory()
    }
}
