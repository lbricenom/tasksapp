//
//  TaskManager.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation

class TaskViewModel : ObservableObject{
    @Published var users: [UserProfile] = []
    @Published var tasks: [TaskModel] = []
    
    private let taskService: TaskService
    
    init(taskService: TaskService) {
        self.taskService = taskService
        Task.detached {
            await self.loadTasks()
            await self.loadUsers()
        }
    }
    
    @discardableResult
    func loadTasks() async -> [TaskModel] {
        do {
            let tasks = try await self.taskService.getTasks()
            DispatchQueue.main.async {
                self.tasks = tasks
            }
            return tasks
        } catch {
            print(error)
        }
        
        return []
    }
    
    @discardableResult
    func loadUsers() async -> [UserProfile]{
        
        do {
            let users = try await self.taskService.getUsers(withRole: nil)
            
            DispatchQueue.main.async {
                self.users = users
            }
            return users
        } catch {
            print(error)
        }
    
        return []
    }
    
    @discardableResult
    func addTask(title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus) throws -> TaskModel {
        guard !title.isEmpty else {
            throw TaskViewModelError.emptyTitle
        }
        
        guard !description.isEmpty else {
            throw TaskViewModelError.emptyDescription
        }
        
        guard let assignedTo = assignedTo, !assignedTo.username.isEmpty else {
            throw TaskViewModelError.emptyAssignee
        }
        
        if assignedTo.role == .admin {
            throw TaskViewModelError.cannotAddTaskToAdminRole
        }
        
        let task = TaskModel(id: tasks.count + 1, title: title, description: description, dueDate: dueDate, assignedTo: assignedTo, status: status)
        tasks.append(task)
        
        return task
    }
    
    func assignTask(_ task: TaskModel, to user: UserProfile) {
        let updatedTask = task
        updatedTask.assignedTo = user
        updatedTask.status = .assigned
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            self.tasks[index] = updatedTask
        }
        Task.detached {
            do {
                try await self.taskService.assignTask(task, to: user)
            }catch {
                print(error)
            }
            
        }
    }
    
    func updateTask(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        self.tasks[index] = task
        Task.detached {
            do {
                try await self.taskService.updateTask(task)
            }catch {
                print(error)
            }
            
        }
    }
    
    func deleteTask(_ task: TaskModel) throws {
        guard task.status == .assigned else {
            throw TaskViewModelError.cannotDeleteTaskInThisStatus
        }
        tasks.removeAll(where: { $0.id == task.id })
        Task.detached {
            do {
                try await self.taskService.deleteTask(task)
            }catch {
                print(error)
            }
            
        }
    }
    
    func getUsers(withRole role: UserRole?) -> [UserProfile] {
        guard let role = role else {
            return users
        }
        return users.filter({ $0.role == role })
    }
    
    func getUser(withId id: Int) -> UserProfile? {
        return users.first(where: { $0.id == id })
    }
}

enum TaskViewModelError: Error {
    case cannotDeleteTaskInThisStatus
    case cannotUpdateTaskInThisStatus
    case cannotAddTaskToAdminRole
    case emptyTitle
    case emptyDescription
    case emptyAssignee
    
    var errorMessage: String {
        switch self {
        case .cannotDeleteTaskInThisStatus:
            return "Cannot delete task in this status."
        case .cannotUpdateTaskInThisStatus:
            return "Cannot update task in this status."
        case .cannotAddTaskToAdminRole:
            return "Cannot add task to an admin user."
        case .emptyTitle:
            return "Title cannot be empty."
        case .emptyDescription:
            return "Description cannot be empty."
        case .emptyAssignee:
            return "Assignee cannot be empty."
        }
    }
}
