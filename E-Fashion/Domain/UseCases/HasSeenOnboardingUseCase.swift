//
//  HasSeenOnboardingUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation

public protocol HasSeenOnboardingUseCase {
    func execute()
}

public struct DefaultHasSeenOnboardingUseCase: HasSeenOnboardingUseCase {
    @Inject private var appStateRepository: AppStateRepository
    
    public init() { }
    
    public func execute() {
        appStateRepository.markHasSeenOnboarding()
    }
}
