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
                                         placeholder: "Search by name",
                                         hidesSearchBarWhenScrolling: false)
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
            ContactCell(searchText: $searchText, contactItem: contactItem)
                .padding()
        }
        .navigationTitle("Contacts")
    }
    
    private func filteredContacts(_ contacts: [ContactItem]) -> [ContactItem] {
        guard searchText.isEmpty else {
            return contacts.filter { contact in
                contact.name.lowercased().contains(searchText.lowercased())
            }
        }
        return contacts
    }
}

fileprivate struct ContactCell: View {
    @Binding var searchText: String
    let contactItem: ContactItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("ID: \(contactItem.id)")

            highlightText(in: contactItem.name,
                          matchingString: searchText)
                .multilineTextAlignment(.leading)

            Text("Phone #: \(contactItem.phoneNumber)")
        }
    }
    
    func highlightText(in string: String, matchingString: String) -> Text {
        guard string.isEmpty == false, matchingString.isEmpty == false else {
            return Text(string)
        }
        
        var result: Text!
        let components = string.components(separatedBy: matchingString)
        
        for index in components.indices {
            result = result == nil
                ? Text(components[index])
                : result + Text(components[index])
            
            guard index != components.count - 1 else {
                continue
            }
            result = result + Text(matchingString).bold()
        }
        return result ?? Text(string)
    }
}

#if !TESTING
struct ContactView_Previews: PreviewProvider {
    static let demoContactItem: ContactItem = .data(1)
    
    static var previews: some View {
        Group {
            ContactView(contactsLoader: LocalContactLoader(with: LocalStorage()))
            ContactCell(searchText: .constant("test"),
                        contactItem: demoContactItem)
        }
    }
}
#endif
