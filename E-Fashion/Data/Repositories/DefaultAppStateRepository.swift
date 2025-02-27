//
//  DefaultAppStateRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine
import FirebaseAuth

public struct DefaultAppStateRepository: AppStateRepository {
    
    public init() { }
    
    public func loadAppState() -> AnyPublisher<AppState, Never> {
        Future<AppState, Never> { promise in
            if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                promise(.success(.onboarding))
                return
            }
            
            if let savedStateRaw = UserDefaults.standard.string(forKey: "appState"),
               let savedState = AppState(rawValue: savedStateRaw) {
                promise(.success(savedState))
                return
            }
            
            let state: AppState = (Auth.auth().currentUser != nil) ? .mainFlow : .authentication
            promise(.success(state))
        }
        .eraseToAnyPublisher()
    }
    
    public func saveAppState(_ state: AppState) {
        UserDefaults.standard.set(state.rawValue, forKey: "appState")
    }
    
    public func markHasSeenOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}
