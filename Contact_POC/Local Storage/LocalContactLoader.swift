//
//  LocalContactLoader.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public final class LocalContactLoader: ContactManager {
    private let storage: PersistentStorage
    
    public enum Error: Swift.Error {
        case invalidQuantity
        case unkown
    }
    
    public typealias Result = LoadContactResult
    
    public init(with storage: PersistentStorage) {
        self.storage = storage
    }
    
    public func load(withQuantity quantity: Int,
                     completion: @escaping (LoadContactResult) -> Void) {
        storage.retrieve(quantity: quantity) { result in
            switch result {
            case let .success(contactItems):
                completion(.success(contactItems))
                
            case .failure:
                completion(.failure(Error.invalidQuantity))
            }
        }
    }
}
