//
//  LoginViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
import Foundation
import Combine

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
}

protocol LoginViewModelInput {
    func forgotPassword()
    func logIn()
    func showPassword()
    func hidePassword()
    func signUp()
    func loginWithFacebook()
    func loginWithGoogle()
}

protocol LoginViewModelOutput {
    var output: AnyPublisher<LoginViewModelOutputAction, Never> { get }
}

enum LoginViewModelOutputAction {
    case successfullLogin
    case loginError(LoginError)
}

final class DefaultLoginViewModel: ObservableObject, LoginViewModel {
    @Inject private var signInUseCase: SignInUseCase
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordIsHidden: Bool = true
    
    private var _output = PassthroughSubject<LoginViewModelOutputAction, Never>()
    var output: AnyPublisher<LoginViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    func forgotPassword() {
        
    }
    
    func logIn() {
        signInUseCase.execute(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?._output.send(.loginError(self?.mapError(error) ?? .unknownError("")))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                self?._output.send(.successfullLogin)
            }.store(in: &subscriptions)

    }
    
    func showPassword() {
        passwordIsHidden = false
    }
    
    func hidePassword() {
        passwordIsHidden = true
    }
    
    func signUp() {
        
    }
    
    func loginWithFacebook() {
//#warning("implement if you have time!!!")
    }
    
    func loginWithGoogle() {
//#warning("implement if you have time!!!")
    }
    
    private func mapError(_ error: Error) -> LoginError {
        if let nsError = error as? NSError {
            switch nsError.code {
            case 17009: 
                return .wrongPassword
            case 17011:
                return .userNotFound
            case 17008:
                return .invalidEmail
            case -1009:
                return .networkError
            default:
                return .unknownError(nsError.localizedDescription)
            }
        }
        return .unknownError("An unexpected error occurred.")
    }
}
