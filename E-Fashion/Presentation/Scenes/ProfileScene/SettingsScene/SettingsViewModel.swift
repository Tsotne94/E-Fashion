//
//  SettingsViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import Combine
import Foundation

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {
}

protocol SettingsViewModelInput {
    func viewDidLoad()
    func fetchUserInfo(fetchImage: Bool)
    func fetchImage()
    func updateImage(image: Data)
    func updateUsername(name: String)
    func goBack()
    func signOut()
    var user: User? { get }
    var profilePicture: Data? { get }
}

protocol SettingsViewModelOutput {
    var output: AnyPublisher<SettingsViewModelOutputAction, Never> { get }
}

enum SettingsViewModelOutputAction {
    case userInfoFetched
    case userimageFethced
}

final class DefaultSettingsViewModel: SettingsViewModel {
    @Inject private var appFlowCoordinator: AppFlowCoordinator
    @Inject private var profileCoordinator: ProfileTabCoordinator
    
    @Inject private var fetchUserInfoUseCase: FetchUserInfoUseCase
    @Inject private var updateUserInfoUseCase: UpdateUserInfoUseCase
    @Inject private var fetchImageUseCase: FetchImageUseCase
    @Inject private var uploadProfileImageUseCase: UploadProfilePictureUseCase
    
    var user: User? = nil
    var profilePicture: Data? = nil
    
    private var _output = PassthroughSubject<SettingsViewModelOutputAction, Never>()
    var output: AnyPublisher<SettingsViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
   
    func viewDidLoad() {
        fetchUserInfo()
    }
    
    func fetchUserInfo(fetchImage: Bool = true) {
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
                if fetchImage {
                    self?.fetchImage()
                }
                self?._output.send(.userInfoFetched)
            }.store(in: &subscriptions)
        
    }
    
    func fetchImage() {
        if let user {
            guard let image = user.imageUrl else { return }
            fetchImageUseCase.execute(urlString: image)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("finished loading user image")
                    case .failure(let error):
                        print("error occured during loading user image, error: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] data in
                    self?.profilePicture = data
                    self?._output.send(.userimageFethced)
                }.store(in: &subscriptions)
        }
    }
    
    func updateImage(image: Data) {
        uploadProfileImageUseCase.execute(image: image)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully updated profile picture")
                case .failure(let errpr):
                    print("failed to updated profile picture error: \(errpr)")
                }
            } receiveValue: { [weak self] _ in
                self?.fetchUserInfo()
            }.store(in: &subscriptions)
    }
    
    func updateUsername(name: String) {
        guard let currentUser = self.user else  { return }

        let updatedUser = User(
            uid: currentUser.uid,
            email: currentUser.email,
            displayName: name,
            imageUrl: currentUser.imageUrl
        )
        
        updateUserInfoUseCase.execute(user: updatedUser)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Username updated successfully")
                case .failure(let error):
                    print("Failed to update username, error: \(error)")
                }
            } receiveValue: { [weak self] _ in
                self?.fetchUserInfo(fetchImage: false)
            }
            .store(in: &subscriptions)
    }
    
    func signOut() {
        appFlowCoordinator.signOut()
    }
    
    func goBack() {
        profileCoordinator.goBack()
    }
}
