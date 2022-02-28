//
//  ContactView.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI

struct ContactView: View {
    var storage: ContactManager
    private let quantity: Int = 10000
    
    var body: some View {
        List(LocalStorage.mockContacts(quantity), id: \.self) { contactItem in
            HStack {
                Text("Id: \(contactItem.id) - Phone #:")
                Text(contactItem.phoneNumber ?? "N/A")
            }
        }
    }
}

#if !TESTING
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(storage: LocalContactLoader(with: LocalStorage()))
    }
}
#endif
