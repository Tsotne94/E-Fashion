//
//  UploadProfilePicture.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import Foundation
import Combine

protocol UploadProfilePictureUseCase {
    func execute(image: Data) -> AnyPublisher<Void, Error>
}

public struct DefaultUploadProfilePictureUseCase: UploadProfilePictureUseCase {
    @Inject private var userRepository: UserRepository
    
    public init() { }
    
    public func execute(image: Data) -> AnyPublisher<Void, Error> {
        userRepository.uploadProfilePicture(image: image)
    }
}
