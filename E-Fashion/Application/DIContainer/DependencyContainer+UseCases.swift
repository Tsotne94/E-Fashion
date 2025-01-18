//
//  DependencyContainer+UseCases.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
public extension DependencyContainer {
    func registerUseCases() {
        DependencyContainer.root.register {
            Module { DefaultLoadAppStateUseCase() as LoadAppStateUseCase }
            Module { DefaultUpdateAppStateUseCase() as UpdateAppStateUseCase }
            Module { DefaultHasSeenOnboardingUseCase() as HasSeenOnboardingUseCase }
            Module { DefaultSignInUseCase() as SignInUseCase }
        }
    }
}
