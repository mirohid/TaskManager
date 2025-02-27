//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.
//


import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var task: TaskEntity
    @State private var showEditView = false

    var priorityColor: Color {
        switch task.priority {
        case "High": return .red
        case "Medium": return .yellow
        case "Low": return .green
        default: return .gray
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Circle()
                    .fill(priorityColor)
                    .frame(width: 50, height: 50)

                Text(task.title ?? "No Title")
                    .font(.title)
                    .bold()

                Text(task.desc ?? "No Description")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()

                Button("Edit Task") {
                    showEditView = true
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showEditView) {
                EditTaskView(task: task)
            }
        }
    }
}
