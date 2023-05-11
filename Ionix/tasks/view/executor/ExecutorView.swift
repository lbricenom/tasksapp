//
//  ExecutorView.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import SwiftUI

struct ExecutorView: View {
       @EnvironmentObject var sessionManager: AuthSessionManager
       @ObservedObject var taskManager: TaskViewModel
       @State private var selectedTask: TaskModel? = nil
       
       let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .short
           formatter.timeStyle = .short
           return formatter
       }()
       
       var body: some View {
           NavigationView {
               List(taskManager.tasks.filter({ $0.assignedTo?.id == sessionManager.userProfile?.id })) { task in
                   VStack(alignment: .leading) {
                       Text(task.title)
                           .font(.headline)
                       Text(task.description)
                           .font(.subheadline)
                           .foregroundColor(.secondary)
                       HStack {
                           Text("Due:")
                           Text("\(task.dueDate, formatter: dateFormatter)")
                       }
                       if let status = task.status {
                           HStack {
                               Text("Status:")
                               Text(status.rawValue.capitalized)
                           }
                       }
                   }
                   .onTapGesture {
                       selectedTask = task
                   }
               }
               .navigationTitle("Tasks")
               .sheet(item: $selectedTask) { task in
                   TaskDetailView(task: task, taskManager: taskManager)
               }
               .onReceive(taskManager.objectWillChange) {
                   // Reload the task list when it changes
                   selectedTask = nil
               }
           }
       }
}
