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
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                }
                Section(header: Text("Accent Color")) {
                    HStack(spacing: 12) {
                        ForEach(colorOptions, id: \.name) { option in
                            Circle()
                                .fill(option.color)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Circle()
                                        .stroke(accentColor == option.name ? Color.primary.opacity(0.6) : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    accentColor = option.name
                                }
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.vertical, 5)
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
