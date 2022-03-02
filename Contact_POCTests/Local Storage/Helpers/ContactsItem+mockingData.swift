//
//  ContactsItem+mockingData.swift
//  Contact_POCTests
//
//  Created by Khang Vu on 3/2/22.
//

import Contact_POC

extension ContactItem {
    static var data: (Int) -> ContactItem = { id in
        .init(id: id,
              name: "testContact ",
              phoneNumber: "00000000",
              emailAddress: "test_email@abc.com",
              address: "testing_address")
    }
}
