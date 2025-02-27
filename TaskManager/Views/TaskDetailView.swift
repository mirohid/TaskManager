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
                Rectangle()
                    .fill(priorityColor)
                    .frame(width: 280, height: 50)
                    .overlay {
                        Text(task.priority ?? "No Priority")
                            .font(.title3)
                            .foregroundColor(.white)
                            .bold()
                    }

                VStack(alignment: .leading){
                    Text("Title:")
                        .font(.title)
                        .bold()
                    Text(task.title ?? "No Title")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.vertical,5)
                    
                    Text("Description:")
                        .font(.title)
                        .bold()
                    
                    Text(task.desc ?? "No Description")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.vertical,5)
                }
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

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let mockTask = TaskEntity(context: context)
    mockTask.title = "Sample Task"
    mockTask.desc = "This is a sample task description."
    mockTask.priority = "High"
    mockTask.isCompleted = false
    mockTask.dueDate = Date()

    return TaskDetailView(task: mockTask)
        .environment(\.managedObjectContext, context)
}
