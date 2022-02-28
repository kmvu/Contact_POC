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

// MARK: - JSON Samples data

extension LocalStorage {
    static func contactsList(quantity: Int) -> [ContactItem] {
        guard let path = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json") else {
            return []
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            
            let jsonResult = try JSONDecoder().decode([ContactItem].self, from: data)
            debugPrint(jsonResult)
            
            return Array(jsonResult[0..<quantity])
        } catch {
            
            return []
        }
    }
}

// MARK: - Mocking for testing

extension LocalStorage {
    static let mockContacts: (Int) -> [ContactItem] = { quantity in
        var contacts: [ContactItem] = []
        
        for id in 1...quantity {
            let item = ContactItem.data(id)
            contacts.append(item)
        }
        return contacts
    }
}
