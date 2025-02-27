//
//  EditTaskView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.
//


import SwiftUI

struct EditTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var task: TaskEntity

    @State private var title: String
    @State private var description: String
    @State private var priority: String
    @State private var dueDate: Date

    let priorities = ["Low", "Medium", "High"]

    init(task: TaskEntity) {
        self.task = task
        _title = State(initialValue: task.title ?? "")
        _description = State(initialValue: task.desc ?? "")
        _priority = State(initialValue: task.priority ?? "Medium")
        _dueDate = State(initialValue: task.dueDate ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Settings")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0) }
                    }

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveTask()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveTask() {
        task.title = title
        task.desc = description
        task.priority = priority
        task.dueDate = dueDate
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}
