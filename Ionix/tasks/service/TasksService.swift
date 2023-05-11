//
//  TasksService.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation


protocol TaskService: NetworkRequestable {
    func getTasks() async throws -> [TaskModel]
    func addTask(title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus) async throws -> TaskModel
    func assignTask(_ task: TaskModel, to user: UserProfile) async throws
    func updateTask(_ task: TaskModel) async throws
    func deleteTask(_ task: TaskModel) async throws
    func getUsers(withRole role: UserRole?) async throws -> [UserProfile]
}

class RemoteTaskService: TaskService {
    
    func getTasks() async throws -> [TaskModel] {
        let endpoint = APIRouter.getTasks
        return try await makeDecodableRequest(for: endpoint)
    }

    func addTask(title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus) async throws -> TaskModel {
        let endpoint = APIRouter.addTask(title: title, description: description, dueDate: dueDate, assignedTo: assignedTo, status: status)
        return try await makeDecodableRequest(for: endpoint)
    }
    
    func assignTask(_ task: TaskModel, to user: UserProfile) async throws {
        let endpoint = APIRouter.assignTask(task: task, user: user)
        return try await makeRequest(for: endpoint)
    }
    
    func updateTask(_ task: TaskModel) async throws {
        let endpoint = APIRouter.updateTask(task: task)
        return try await makeRequest(for: endpoint)
    }
    
    func deleteTask(_ task: TaskModel) async throws {
        let endpoint = APIRouter.deleteTask(task: task)
        return try await makeRequest(for: endpoint)
    }
    
    func getUsers(withRole role: UserRole?) async throws -> [UserProfile] {
        let endpoint = APIRouter.getUsers(role: role)
        return try await makeDecodableRequest(for: endpoint)
    }
}

enum TaskServiceError: Error {
    case networkError
    case invalidResponse
    case taskNotFound
    case userNotFound
    case invalidData
    case unauthorized
}
