//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by Luka Vujnovac on 02.11.2021..
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
