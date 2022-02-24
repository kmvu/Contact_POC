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
        case invalidData
        case unkwown
    }
    
    public init(with storage: PersistentStorage) {
        self.storage = storage
    }
    
    public func load(completion: @escaping (LoadContactResult) -> Void) {
        storage.retrieve(quantity: 10) { result in
        }
    }
}
