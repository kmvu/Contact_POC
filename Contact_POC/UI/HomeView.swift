//
//  HomeView.swift
//  Contact_POC
//
//  Created by Khang Vu on 01/03/2022.
//

import SwiftUI

struct HomeView: View {
    @State var quantity: String = ""
    @State var isActive: Bool = false
    
    @ObservedObject var contactsLoader: LocalContactLoader

    var body: some View {
        VStack {
            // Textfield to key in the number of contacts to retrieve from storage.
            Spacer()
            VStack {
                Text("Number of contacts")
                    .font(.body)
                
                HStack {
                    Spacer()
                    
                    TextField("Type here...", text: $quantity)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    
                    Spacer()
                }
            }
            Spacer()
            
            // Show Contacts button - click on to see the list of items.
            let contactView = ContactView(contactsLoader: contactsLoader)
                .onAppear {
                    contactsLoader.load(withQuantity: Int(quantity) ?? 0) { result in
                        contactsLoader.contacts = result
                    }
                }
            
            NavigationLink(destination: contactView, isActive: $isActive) {
                Button("Show Contacts") { isActive = true }
            }
            .navigationTitle("Contacts POC")

            Spacer()
        }
    }
}

#if !TESTING
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(contactsLoader: LocalContactLoader(with: LocalStorage()))
    }
}
#endif
