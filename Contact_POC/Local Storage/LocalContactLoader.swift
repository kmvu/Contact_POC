//
//  LocalContactLoader.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public final class LocalContactLoader: ContactManager {
    private let storage: PersistentStorage
    private let contactQuantity: Int
    
    public enum Error: Swift.Error {
        case invalidQuantity
        case unkown
    }
    
    public typealias Result = LoadContactResult
    
    public init(with storage: PersistentStorage, quantity: Int) {
        self.storage = storage
        self.contactQuantity = quantity
    }
    
    public func load(completion: @escaping (LoadContactResult) -> Void) {
        storage.retrieve(quantity: contactQuantity) { result in
            switch result {
            case let .success(contactItems):
                completion(.success(contactItems))
                
            case .failure(Error.invalidQuantity):
                completion(.failure(Error.invalidQuantity))
                
            default:
                completion(.failure(Error.unkown))
            }
        }
    }
}
