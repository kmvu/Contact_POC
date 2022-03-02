//
//  Contact_POCApp.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI

@main
struct Contact_POCApp: App {
    private static let resourceFileName = "MOCK_DATA"
    
    @StateObject var contactsLoader = LocalContactLoader(
        with: LocalStorage(resourceFileName: resourceFileName))
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(contactsLoader: contactsLoader)
            }
        }
    }
}
