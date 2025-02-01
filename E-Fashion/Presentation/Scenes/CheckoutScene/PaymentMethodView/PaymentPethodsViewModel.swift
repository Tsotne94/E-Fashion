//
//  PaymentPethodsViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Foundation
import Combine

protocol PaymentMethodsViewModel: PaymentMethodsViewModelInput, PaymentMethodsViewModelOutput {
}

protocol PaymentMethodsViewModelInput {
    func fetchPaymentMethods()
    func addPaymentMethod(_ method: CardModel)
    func removePaymentMethod(_ method: CardModel)
    func setDefaultPaymentMethod(_ method: CardModel)
    func dismissPresented()
    func validateName(_ name: String) -> Bool
    func validateCardNumber(_ number: String) -> Bool
    func validateExpiry(_ date: String) -> Bool
    func validateCCV(_ ccv: String) -> Bool
    func formatCardPlaceholder(_ input: String) -> String
    func formatCreditCardNumber(_ input: String) -> String
    func formatExpiryDate(_ expiryDate: String) -> String
    func formatCCV(_ ccv: String) -> String
    var paymentMethods: [CardModel] { get }
}

protocol PaymentMethodsViewModelOutput {
    var output: AnyPublisher<PaymentMethodsViewModelOutputAction, Never> { get }
}

enum PaymentMethodsViewModelOutputAction {
    case error(Error)
}

final class DefaultPaymentMethodsViewModel: ObservableObject, PaymentMethodsViewModel {
    @Inject private var bagCoordinator: BagTabCoordinator
    @Inject private var paymentRepository: PaymentRepository
    private var cancellables = Set<AnyCancellable>()
    
    private let _output = PassthroughSubject<PaymentMethodsViewModelOutputAction, Never>()
    
    var output: AnyPublisher<PaymentMethodsViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    @Published var paymentMethods: [CardModel] = []
    
    init() { }
    
    func fetchPaymentMethods() {
        paymentRepository.fetchPaymentMethods()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] methods in
                self?.paymentMethods = methods.sorted(by: { $0.isDefault && !$1.isDefault })
            })
            .store(in: &cancellables)
    }
    
    func addPaymentMethod(_ method: CardModel) {
        paymentRepository.addPaymentMethod(method: method)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchPaymentMethods()
            })
            .store(in: &cancellables)
    }
    
    func removePaymentMethod(_ method: CardModel) {
        let methodId = method.id
        
        paymentRepository.removePaymentMethod(id: methodId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchPaymentMethods()
            })
            .store(in: &cancellables)
    }
    
    func setDefaultPaymentMethod(_ method: CardModel) {
        guard !method.isDefault else { return }
        
        let methodId = method.id
        
        paymentRepository.updateDefaultPaymentMethod(id: methodId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchPaymentMethods()
            })
            .store(in: &cancellables)
    }
    
    func dismissPresented() {
        bagCoordinator.dismissPresented()
    }
    
    func validateName(_ name: String) -> Bool {
        let cleaned = formatCardPlaceholder(name)
        return cleaned.count >= 3
    }
    
    func validateCardNumber(_ number: String) -> Bool {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        return cleaned.count >= 15 && cleaned.count <= 16
    }
    
    func validateExpiry(_ date: String) -> Bool {
        guard date.count == 5,
              let month = Int(date.prefix(2)),
              let year = Int(date.suffix(2)) else { return false }
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        return month >= 1 && month <= 12 &&
               (year > currentYear || (year == currentYear && month >= currentMonth))
    }
    
    func validateCCV(_ ccv: String) -> Bool {
        let cleaned = ccv.replacingOccurrences(of: " ", with: "")
        return cleaned.count == 3 || cleaned.count == 4
    }
    
    func formatCardPlaceholder(_ input: String) -> String {
        let cleanedString = input.filter { $0.isLetter || $0.isWhitespace }
        return cleanedString
    }
    
    func formatCreditCardNumber(_ input: String) -> String {
        let digitsOnly = input.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        let formatted = digitsOnly.enumerated().map { index, char -> String in
            return (index % 4 == 0 && index > 0) ? " \(char)" : "\(char)"
        }.joined()
        
        return String(formatted.prefix(19))
    }
    
    func formatExpiryDate(_ expiryDate: String) -> String {
        let cleanedString = expiryDate.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var formattedString = ""
        for (index, character) in cleanedString.enumerated() {
            if index == 2 {
                formattedString.append("/")
            }
            formattedString.append(character)
            
            if formattedString.count == 5 {
                break
            }
        }
        
        return formattedString
    }
    
    func formatCCV(_ ccv: String) -> String {
        let cleanedString = ccv.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var formattedString = ""
        for (_, character) in cleanedString.prefix(3).enumerated() {
            formattedString.append(character)
        }
        
        return formattedString
    }
}
