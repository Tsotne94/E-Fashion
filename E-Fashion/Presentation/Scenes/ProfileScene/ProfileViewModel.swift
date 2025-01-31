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
    func updateProfileImage(image: Data)
    func changeUserName(name: String)
    func goToAddresses()
    func goToPaymentMethods()
    func goToSettings()
    func logout()
    var numberOfOrders: Int? { get }
    var numberOfAdresses: Int? { get }
    var paymentMethod: CardModel? { get }
}

protocol ProfileViewModelOutput {
    var output: AnyPublisher<ProfileViewModelOutputAction, Never> { get }
}

enum ProfileViewModelOutputAction {
    case profileInfoFetched
    case profileImageFetched
    case userNameChanged
}

final class DefautlProfileViewModel: ProfileViewModel {
    @Inject private var profileCoordinator: ProfileTabCoordinator
    
    private var _output = PassthroughSubject<ProfileViewModelOutputAction, Never>()
    var output: AnyPublisher<ProfileViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    var numberOfOrders: Int?
    
    var numberOfAdresses: Int?
    
    var paymentMethod: CardModel?
    
    func viewDidLoad() {
        
    }
    
    func fetchUserInfo() {
        
    }
    
    func loadUserImage() {
        
    }
    
    func updateProfileImage(image: Data) {
        
    }
    
    func changeUserName(name: String) {
        
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
    
    func logout() {
        
    }
}
