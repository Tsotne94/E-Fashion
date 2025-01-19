//
//  SignUpViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
import Combine
import Foundation

protocol SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {
}

protocol SignUpViewModelInput {
    func signUp()
    func showPassword()
    func hidePassword()
    func showConfirmPassword()
    func hideConfirmPassword()
    func goToLogin()
    
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var confirmPasswod: String { get set }
    var passwordIsHidden: Bool { get set }
    var confirmPasswordHidden: Bool { get set }
    var isLoading: Bool { get set }
}

protocol SignUpViewModelOutput {
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> { get }
}

enum SignUpViewModelOutputAction {
    case successfullSignUp
    case passwordsDoNotMatch
    case signUpError(SignUpError)
}

final class DefaultSignUpViewModel: SignUpViewModel, ObservableObject {
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
    @Inject private var signUpUseCase: SignUpUseCase
    @Inject private var saveUser: SaveUserUseCase
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordIsHidden: Bool = true
    @Published var isLoading: Bool = false
    @Published var confirmPasswod: String = ""
    @Published var confirmPasswordHidden: Bool = true
    private var _output = PassthroughSubject<SignUpViewModelOutputAction, Never>()
    
    @MainActor
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func signUp() {
        if validatePasswords() {
            signUpUseCase.execute(email: email, password: password)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?._output.send(.successfullSignUp)
                    case .failure(let error):
                        let mappedError: SignUpError = ErrorMapper.map(error)
                        self?._output.send(.signUpError(mappedError))
                    }
                } receiveValue: { user in
                    print("cool")
                }.store(in: &subscriptions)

        } else {
            _output.send(.passwordsDoNotMatch)
        }
    }
    
    func showPassword() {
        
    }
    
    func hidePassword() {
        
    }
    
    func showConfirmPassword() {
        
    }
    
    func hideConfirmPassword() {
        
    }
    
    func goToLogin() {
        
    }
    
    func validatePasswords() -> Bool {
        return password == confirmPasswod
    }
 
}
