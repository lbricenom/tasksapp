//
//  TaskDetail.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var sessionManager: AuthSessionManager
    @ObservedObject var task: TaskModel
    @ObservedObject var taskManager: TaskViewModel
    @State private var showingErrorModal = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isAddingExecutor = false
    @State private var selectedExecutor: UserProfile? = nil
    @State private var editMode = EditMode.inactive
    @State private var pickerStatus: TaskStatus = .assigned
    @State private var newComment: String = ""

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var statusOptions: [TaskStatus] {
        switch pickerStatus {
        case .new, .assigned:
            return [.assigned, .inprogress]
        case .inprogress:
            return [.inprogress, .waiting, .doneWithError, .doneSuccessfully]
        case .waiting:
            return [.waiting, .inprogress]
        case .doneSuccessfully, .doneWithError:
            return [pickerStatus]
            
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            TextField("Title", text: $task.title)
                .font(.title)
                .disabled(editMode == .inactive)
            TextField("Description", text: $task.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .disabled(editMode == .inactive)
            HStack {
                Text("Due:")
                DatePicker("", selection: $task.dueDate, displayedComponents: [.date, .hourAndMinute])
                    .disabled(editMode == .inactive)
            }.frame(height: 100)
            
            Group {
                
                Text("Comments:")
                if !(task.comments?.isEmpty ?? false) {
                    ForEach(task.comments ?? [], id: \.self) { comment in
                        Text(comment)
                    }
                } else {
                    Text("No comments yet.")
                        .foregroundColor(.secondary)
                }

                TextField("Add comment...", text: $newComment, onCommit: {
                    if !newComment.isEmpty {
                        task.comments?.append(newComment)
                        taskManager.updateTask(task)
                        newComment = ""
                    }
                })
                .keyboardType(.webSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom)
            }
            HStack {
                Text("Assigned to:")
                Text(task.assignedTo?.username ?? "Unassigned")

                if editMode == .active {
                    Button(action: {
                        isAddingExecutor = true
                    }) {
                        Text("Add")
                    }
                    .sheet(isPresented: $isAddingExecutor) {
                        NavigationView {
                            List(taskManager.getUsers(withRole: .executor)) { user in
                                Button(action: {
                                    selectedExecutor = user
                                    isAddingExecutor = false
                                }) {
                                    HStack {
                                        Text(user.username)
                                        if selectedExecutor?.id == user.id {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            .navigationTitle("Select Executor")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        isAddingExecutor = false
                                    }) {
                                        Text("Cancel")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if sessionManager.getCurrentRole() == .executor {
                Text("Status:")
                
                Picker("", selection: $pickerStatus) {
                    ForEach(statusOptions, id: \.self) { status in
                        Text(status.rawValue.localizedCapitalized)
                            .tag(status)
                    }
                }
                .onChange(of: pickerStatus) { newValue in
                    if newValue != task.status {
                        
                        task.status = newValue
                        taskManager.updateTask(task)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
          
        }
        .padding()
        .navigationTitle("Task Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if task.status == .assigned || task.status == .assigned {
                    EditButton()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if editMode == .active && task.status == .assigned || task.status == .assigned {
                    Button(action: {
                        do {
                            try taskManager.deleteTask(task)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            errorMessage = error.localizedDescription.description
                            showingErrorModal = true
                        }
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $showingErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: selectedExecutor) { newValue in
            if let newValue = newValue {
                task.assignedTo = newValue
            }
        }
        .environment(\.editMode, $editMode)
        .onAppear {
            pickerStatus = task.status
        }
    }
}

