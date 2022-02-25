//
//  ContactItem.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public struct ContactItem: Equatable {
    public let id: UUID
    public let name: String
    public let phoneNumber: String?
    public let emailAddress: String?
    public let address: String?
    
    public init(id: UUID,
                name: String,
                phoneNumber: String?,
                emailAddress: String?,
                address: String?) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.address = address
    }
}

public extension ContactItem {
    static var data: ContactItem {
        .init(id: UUID(),
              name: "testContact",
              phoneNumber: "00000000",
              emailAddress: "test_email@abc.com",
              address: "testing_address")
    }
}
