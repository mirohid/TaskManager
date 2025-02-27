//
//  TaskListView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.


import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)],
        animation: .default)
    private var tasks: FetchedResults<TaskEntity>

    @State private var showAddTaskView = false
    @State private var selectedTask: TaskEntity?
    @State private var filterStatus = "All"
    @State private var sortOrder = "Title"

    let filterOptions = ["All", "Completed", "Pending"]
    let sortOptions =  ["Due Date", "Priority", "Title"]

    var filteredTasks: [TaskEntity] {
        tasks.filter { task in
            switch filterStatus {
            case "Completed": return task.isCompleted
            case "Pending": return !task.isCompleted
            default: return true
            }
        }
        .sorted {
            switch sortOrder {
            case "Priority":
                return priorityRank($0.priority) > priorityRank($1.priority) // High → Medium → Low
            case "Title":
                return $0.title ?? "" < $1.title ?? ""
            default:
                return $0.dueDate ?? Date() < $1.dueDate ?? Date()
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Picker("Filter", selection: $filterStatus) {
                            ForEach(filterOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.segmented)

                        Picker("Sort", selection: $sortOrder) {
                            ForEach(sortOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)

                if filteredTasks.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "tray.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No tasks available. Start by adding one!")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            TaskRowView(task: task)
                                .onTapGesture {
                                    selectedTask = task
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Task Manager")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddTaskView = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .scaleEffect(showAddTaskView ? 1.1 : 1)
                            .animation(.spring(), value: showAddTaskView)
                    }
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task)
            }
        }
    }

    private func deleteTask(_ task: TaskEntity) {
        viewContext.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }

    private func priorityRank(_ priority: String?) -> Int {
        switch priority {
        case "High": return 3
        case "Medium": return 2
        case "Low": return 1
        default: return 0
        }
    }
}

#Preview {
    TaskListView()
}
