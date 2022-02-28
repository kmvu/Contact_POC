//
//  LocalStorage.swift
//  Contact_POC
//
//  Created by Khang Vu on 2/28/22.
//

import Foundation

public class LocalStorage: PersistentStorage {

    public init() {}

    /// Retrieve data from local storage. Either from a persistent one or from an assumed data like this as mentioned from requirement.
    public func retrieve(quantity: Int, completion: @escaping (Result<[ContactItem], Error>) -> Void) {
        guard quantity >= 0 else {
            completion(.failure(LocalContactLoader.Error.invalidQuantity))
            return
        }

        let resultContacts = Array(1...quantity).map { id in
            ContactItem.data(id)
        }
        completion(.success(resultContacts))
    }
}
