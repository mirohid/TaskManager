//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.
//


import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
