//
//  SettingsView.swift
//  DemoCrudCD2
//
//  Created by MacMini6 on 27/02/25.



import SwiftUI

struct SettingsView: View {
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    let colorOptions: [(name: String, color: Color)] = [
        ("Blue", .blue),
        ("Red", .red),
        ("Green", .green),
        ("Orange", .orange),
        ("Purple", .purple),
        ("Yellow", .yellow)
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }

                    Picker("Accent Color", selection: $accentColor) {
                        ForEach(colorOptions, id: \.name) { option in
                            HStack {
                                Circle()
                                    .fill(option.color)
                                    .frame(width: 20, height: 20)
                                Text(option.name)
                            }
                            .tag(option.name)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                applyAccentColor()
            }
        }
    }

    private func applyAccentColor() {
        if let selectedColor = colorOptions.first(where: { $0.name == accentColor })?.color {
            UIApplication.shared.windows.first?.tintColor = UIColor(selectedColor)
        }
    }
}

#Preview {
    SettingsView()
}
