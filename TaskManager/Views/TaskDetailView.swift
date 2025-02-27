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
        case "High":
            return Color.red
        case "Medium":
            return Color.yellow
        case "Low":
            return Color.green
        default:
            return Color.blue
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //Priority Banner
                RoundedRectangle(cornerRadius: 12)
                    .fill(priorityColor)
                    .frame(width: 300, height: 50)
                    .shadow(radius: 5)
                    .overlay {
                        Text(task.priority ?? "No Priority")
                            .font(.title3)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 15) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(task.title ?? "No Title")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    }

                    //  Description Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(task.desc ?? "No Description")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    }

                    // Due Date Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(task.dueDate?.formatted(date: .abbreviated, time: .omitted) ?? "No Due Date")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    }
                }
                .padding(.horizontal)

                // Edit Button
                Button(action: { showEditView = true }) {
                    ZStack {
                        Text("Edit Task")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
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

