//
//  ContactView.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI
import SwiftlySearch

struct ContactView: View {
    @ObservedObject var contactsLoader: LocalContactLoader
    @State private var searchText: String = ""
    
    var body: some View {
        switch contactsLoader.contacts {
        case let .success(contacts):
            if #available(iOS 15.0, *) {
                ContactsList(contacts: contacts, searchText: $searchText)
                    .searchable(text: $searchText,
                                placement: .navigationBarDrawer(displayMode: .always),
                                prompt: "Search by name")
                
            } else { // Fallback on earlier versions
                ContactsList(contacts: contacts, searchText: $searchText)
                    .navigationBarSearch($searchText,
                                         placeholder: "Search by name")
            }

        case .failure:
            Text("There are no contacts found.")
        }
    }
}

struct ContactsList: View {
    var contacts: [ContactItem]
    @Binding var searchText: String
    
    var body: some View {
        List(filteredContacts(contacts), id: \.self) { contactItem in
            VStack(alignment: .leading, spacing: 8.0) {
                Text("ID: \(contactItem.id)")
                Text("Name: \(contactItem.name)")
                Text("Phone #: \(contactItem.phoneNumber)")
            }
        }
        .navigationTitle("Contacts")
    }
    
    private func filteredContacts(_ contacts: [ContactItem]) -> [ContactItem] {
        guard searchText.isEmpty else {
            return contacts.filter { contact in
                contact.name.contains(searchText)
            }
        }
        return contacts
    }
}

#if !TESTING
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contactsLoader: LocalContactLoader(with: LocalStorage()))
    }
}
#endif
