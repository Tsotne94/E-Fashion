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
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
}

protocol SignUpViewModelOutput {
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> { get }
}

enum SignUpViewModelOutputAction {
    case successfullSignUp
    case signUpError(SignUpError)
}

final class DefaultSignUpViewModel: SignUpViewModel, ObservableObject {
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    @Inject private var signUpUseCase: SignUpUseCase
    @Inject private var saveUserUseCase: SaveUserUseCase
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordIsHidden: Bool = true
    @Published var isLoading: Bool = false
    @Published var confirmPasswod: String = ""
    @Published var confirmPasswordHidden: Bool = true
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var _output = PassthroughSubject<SignUpViewModelOutputAction, Never>()
    
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        _output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .successfullSignUp:
                    self?.alertTitle = "Success!"
                    self?.alertMessage = "Successfull Sign Up!"
                    self?.showAlert = true
                case .signUpError(let error):
                    self?.alertTitle = "Error Occured During Registration!"
                    self?.alertMessage = error.description
                    self?.showAlert = true
                }
            }.store(in: &subscriptions)
    }
    
    func signUp() {
        isLoading = true
        checkIfSignedUp()
    }

    private func checkIfSignedUp() {
        getCurrentUserUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleSignUp()
                }
            } receiveValue: { [weak self] user in
                self?.saveUser(user.uid)
            }.store(in: &subscriptions)
    }

    private func handleSignUp() {
        if validateInputs() {
            signUpUseCase.execute(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isLoading = false
                        self?._output.send(.successfullSignUp)
                    case .failure(let error):
                        self?.isLoading = false
                        let mappedError: SignUpError = ErrorMapper.map(error)
                        self?._output.send(.signUpError(mappedError))
                    }
                } receiveValue: { [weak self] user in
                    self?.saveUser(user.uid)
                }.store(in: &subscriptions)
        } else {
            isLoading = false
        }
    }

    private func saveUser(_ userId: String) {
        let user = User(uid: userId, email: email, displayName: name)
        saveUserUseCase.execute(user: user)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.authenticationCoordinator.successfullLogin()
                case .failure(let error):
                    let mappedError: SignUpError = ErrorMapper.map(error)
                    self?._output.send(.signUpError(mappedError))
                    
                    self?.alertTitle = "Error"
                    self?.alertMessage = "Failed to save user information. Please try again."
                    self?.showAlert = true
                }
            } receiveValue: { _ in
                print("User info saved successfully")
            }.store(in: &subscriptions)
    }

    func showPassword() {
        passwordIsHidden = false
    }
    
    func hidePassword() {
        passwordIsHidden = true
    }
    
    func showConfirmPassword() {
        confirmPasswordHidden = false
    }
    
    func hideConfirmPassword() {
        confirmPasswordHidden = true
    }
    
    func goToLogin() {
        authenticationCoordinator.goBack(animated: true)
    }
    
    func validateInputs() -> Bool {
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPasswod.isEmpty else {
            
            _output.send(.signUpError(.unknownError("All fields are required")))
            return false
        }
        
        guard password == confirmPasswod else {
            _output.send(.signUpError(.unknownError("Passwords do not match")))
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            _output.send(.signUpError(.invalidEmail))
            return false
        }
        
        return true
    }
}
