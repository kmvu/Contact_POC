//
//  ContactManager.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public enum LoadContactResult {
    case success([ContactItem])
    case failure(Error)
}

public protocol ContactManager {
    func load(completion: @escaping (LoadContactResult) -> Void)
}
