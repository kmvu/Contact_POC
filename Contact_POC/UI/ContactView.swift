//
//  ContactView.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI
import Combine

private class ContactsViewModel: ObservableObject {
    @Published var contacts: (Int) -> [ContactItem] = { quantity in
        LocalStorage.contactsList(quantity: quantity)
    }
}

struct ContactView: View {
    @StateObject fileprivate var viewModel = ContactsViewModel()
    var storage: ContactManager
    
    var body: some View {
        List(viewModel.contacts(10000), id: \.self) { contactItem in
            VStack(alignment: .leading, spacing: 8.0) {
                Text("ID: \(contactItem.id)")
                Text("Name: \(contactItem.name)")
                Text("Phone #: \(contactItem.phoneNumber)")
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
