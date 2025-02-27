//
//  AddTaskView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.


import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var priority = "Medium"
    @State private var dueDate = Date()

    let priorities = ["Low", "Medium", "High"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityLabel("Task Title")
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityLabel("Task Description")
                }

                Section(header: Text("Settings")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0) }
                    }
                    .accessibilityLabel("Priority Selection")

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        .accessibilityLabel("Due Date Picker")
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { addTask() }
                        .disabled(title.isEmpty)
                        .animation(.easeInOut, value: title.isEmpty)
                }
            }
        }
    }

    private func addTask() {
        let newTask = TaskEntity(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.desc = description
        newTask.priority = priority
        newTask.dueDate = dueDate
        newTask.isCompleted = false
        newTask.createdAt = Date()

        saveContext()
        dismiss()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddTaskView()
}
