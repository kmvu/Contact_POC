//
//  ContactItem.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import Foundation

public struct ContactItem: Equatable, Identifiable, Codable, Hashable {
    public let id: Int
    public let name: String
    public var phoneNumber: String
    public let emailAddress: String?
    public let address: String?
    
    public init(id: Int,
                name: String,
                phoneNumber: String,
                emailAddress: String?,
                address: String?) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.address = address
    }
}
