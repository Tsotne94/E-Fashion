//
//  AppStateRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Combine

protocol AppStateRepository {
    func loadAppState() -> AnyPublisher<AppState, Never>
    func saveAppState(_ state: AppState)
    func markHasSeenOnboarding()
}
