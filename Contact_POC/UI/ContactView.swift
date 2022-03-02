//
//  ContactView.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI

struct ContactView: View {
    @ObservedObject var contactsLoader: LocalContactLoader
    
    var body: some View {
        switch contactsLoader.contacts {
        case let .success(contacts):
            List(contacts, id: \.self) { contactItem in
                VStack(alignment: .leading, spacing: 8.0) {
                    Text("ID: \(contactItem.id)")
                    Text("Name: \(contactItem.name)")
                    Text("Phone #: \(contactItem.phoneNumber)")
                }
            }
            .navigationTitle("Contacts")

        case .failure:
            Text("There are no contacts found.")
        }
    }
}

#if !TESTING
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contactsLoader: LocalContactLoader(with: LocalStorage()))
    }
}
#endif
