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

extension LocalStorage {
    static var mockContacts: (Int) -> [ContactItem] = { quantity in
        var contacts: [ContactItem] = []
        
        for id in 1...quantity {
            var item = ContactItem.data(id)
            item.phoneNumber = "123456789".random()
            
            contacts.append(item)
        }
        return contacts
    }
}

extension String {
    func random() -> String {
        return String(Int.random(in: 123456789..<((123456789 * 10) + 9)))
    }
}
