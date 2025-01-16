//
//  FirstTabViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import Combine

class FirstTabViewModel: ObservableObject {
    @Published var nname = "name"
    
    var subscriptions = Set<AnyCancellable>()
       
       init() {
           $nname
               .sink { newValue in
                   print("nname updated: \(newValue)")
               }
               .store(in: &subscriptions)
       }
}
