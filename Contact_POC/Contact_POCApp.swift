//
//  Contact_POCApp.swift
//  Contact_POC
//
//  Created by Khang Vu on 23/02/2022.
//

import SwiftUI

@main
struct Contact_POCApp: App {
    let contactManager: ContactManager = LocalContactLoader(with: LocalStorage())
    
    var body: some Scene {
        WindowGroup {
            ContactView(storage: contactManager)
        }
    }
}
