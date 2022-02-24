//
//  PersistentStorage.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public protocol PersistentStorage {
    func retrieve(quantity: Int,
                  completion: @escaping (Result<ContactItem, Error>) -> Void)
}
