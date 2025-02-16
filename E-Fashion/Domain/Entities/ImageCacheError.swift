//
//  ImageCacheError.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

public enum ImageCacheError: Error {
    case notFound
    case invalidData
    case storageError(Error)
    case saveFailed
}
