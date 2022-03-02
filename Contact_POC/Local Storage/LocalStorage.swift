//
//  LocalStorage.swift
//  Contact_POC
//
//  Created by Khang Vu on 2/28/22.
//

import Foundation

// MARK: - Persistent Storage

public protocol PersistentStorage {
    
    /// Returns the first `quantity` number of contacts from storage
    /// And it could be retrieved from any kind of persistence storage such as CoreData or Realm.
    func retrieve(quantity: Int,
                  completion: @escaping (Result<[ContactItem], Error>) -> Void)
}

// MARK: - Local Storage

public class LocalStorage: PersistentStorage {

    public let resourceName: String
    
    public init(resourceFileName: String = "") {
        self.resourceName = resourceFileName
    }

    /// Retrieve data from local storage. Either from a persistent one or from an assumed data like this as mentioned from requirement.
    public func retrieve(quantity: Int, completion: @escaping (Result<[ContactItem], Error>) -> Void) {
        guard quantity >= 0 else {
            completion(.failure(LocalContactLoader.Error.invalidQuantity))
            return
        }

        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            completion(.failure(LocalContactLoader.Error.empty))
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode([ContactItem].self, from: data)
            
            completion(.success(Array(jsonResult[0..<quantity])))
        } catch {
            completion(.failure(LocalContactLoader.Error.invalidFormat))
        }
    }
}
