//
//  TaskRowView.swift
//  TaskManager
//
//  Created by MacMini6 on 27/02/25.

import SwiftUI

struct TaskRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: TaskEntity

    var priorityColor: Color {
        switch task.priority {
        case "High": return .red
        case "Medium": return .yellow
        case "Low": return .green
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Priority Indicator
            Circle()
                .fill(priorityColor)
                .frame(width: 12, height: 12)
                .padding(.leading, 5)

            // Task Info
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title ?? "No Title")
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .strikethrough(task.isCompleted, color: .gray)

                if let desc = task.desc, !desc.isEmpty {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Complete Task Button
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
        .padding(.horizontal)
    }

    private func toggleCompletion() {
        task.isCompleted.toggle()
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving task completion: \(error.localizedDescription)")
        }
    }
}
