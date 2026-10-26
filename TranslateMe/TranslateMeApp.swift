//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Sophia Sartor on 10/25/26.
//

//
//  TranslateMeApp.swift
//  TranslateMe
//

import SwiftUI
import FirebaseCore

@main
struct TranslateMeApp: App {

    // need to start firebase before anything uses firestore
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
