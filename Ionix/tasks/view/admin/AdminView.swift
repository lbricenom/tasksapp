//
//  AdminView.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import SwiftUI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct AdminView: View {
    @EnvironmentObject var sessionManager: AuthSessionManager
    @ObservedObject var taskManager: TaskViewModel
    @State private var isPresentingAddTaskSheet = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    var body: some View {
        NavigationView {
            List(taskManager.tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task, taskManager: taskManager)) {
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                        Text(task.description)
                            .font(.subheadline)
                        Text("Due: \(task.dueDate, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddTaskSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddTaskSheet) {
                AddTaskSheet(isPresented: $isPresentingAddTaskSheet, taskManager: taskManager)
            }
        }
    }
}



struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(taskManager: TaskViewModel(taskService: MockedRemoteTaskService()))
    }
}


struct AddTaskSheet: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    @ObservedObject var taskManager: TaskViewModel
    @State private var selectedUser: UserProfile?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                
                Section(header: Text("Description")) {
                    TextField("Enter description", text: $description)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                }
                Section(header: Text("Assignee")) {
                    Text("Select assignee")
                        .foregroundColor(.secondary)
                    NavigationLink(destination: UserListView(selectedUser: $selectedUser, taskManager: taskManager)) {
                        Text(selectedUser?.username ?? "")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                Section {
                    Button("Add Task") {
                        do {
                            try taskManager.addTask(title: title, description: description, dueDate: dueDate, assignedTo: selectedUser, status: .assigned)
                            isPresented = false
                        } catch let error as TaskViewModelError {
                            showAlert = true
                            alertMessage = error.errorMessage
                        } catch {
                            showAlert = true
                            alertMessage = "An error occurred while adding the task."
                        }
                    }
                }
            }
            .navigationBarTitle("Add Task")
            .navigationBarItems(trailing: Button("Cancel") { isPresented = false })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UserListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedUser: UserProfile?
    @ObservedObject var taskManager: TaskViewModel
    
    var body: some View {
        List(taskManager.getUsers(withRole: .executor)) { user in
            Button(action: {
                selectedUser = user
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text(user.username)
                    Spacer()
                    if selectedUser?.id == user.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationBarTitle("Select Assignee")
    }
}
