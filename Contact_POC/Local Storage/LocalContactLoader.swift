//
//  LocalContactLoader.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public final class LocalContactLoader: ContactManager, ObservableObject {
    private let storage: PersistentStorage
    @Published var contacts: Result = .failure(Error.empty)
    
    public enum Error: Swift.Error {
        case invalidQuantity // When the requested quantity is less then 0
        case invalidFormat   // When the parsed response format is invalid
        case empty           // When there are no response
    }
    
    public typealias Result = LoadContactResult
    
    public init(with storage: PersistentStorage) {
        self.storage = storage
    }
    
    public func load(withQuantity quantity: Int,
                     completion: @escaping (LoadContactResult) -> Void) {
        storage.retrieve(quantity: quantity) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(contactItems):
                guard contactItems.isEmpty == false else {
                    self.contacts = .failure(Error.empty)
                    completion(self.contacts)
                    return
                }
                self.contacts = .success(contactItems) // Publish back the items
                completion(self.contacts)
                
            case let .failure(error):
                self.contacts = .failure(error)
                completion(.failure(error))
            }
        }
    }
}
