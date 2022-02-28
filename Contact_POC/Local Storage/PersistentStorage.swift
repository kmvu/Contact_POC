//
//  PersistentStorage.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public protocol PersistentStorage {
    
    /// Returns the first `quantity` number of contacts from storage
    /// And it could be retrieved from any kind of persistence storage such as CoreData or Realm.
    func retrieve(quantity: Int,
                  completion: @escaping (Result<[ContactItem], Error>) -> Void)
}
