//
//  ContentView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color.accentColor)
    }
}

#Preview {
    ContentView()
}
