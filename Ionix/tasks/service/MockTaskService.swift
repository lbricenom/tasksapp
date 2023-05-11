//
//  MockTaskService.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation

 class MockedRemoteTaskService: TaskService, JSONLoader {
    
    func getTasks() async throws -> [TaskModel] {
        let tasks = try loadJSONData(fromFileNamed: "tasks") as [TaskModel]
        return tasks
    }
    
    func addTask(title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus) async throws -> TaskModel {
        let task = TaskModel(id: UUID().hashValue, title: title, description: description, dueDate: dueDate, assignedTo: assignedTo, status: status)
        task.dueDate = Date()
        return task
    }
    
    func assignTask(_ task: TaskModel, to user: UserProfile) async throws {
    }
    
    func updateTask(_ task: TaskModel) async throws {
    }
    
    func deleteTask(_ task: TaskModel) async throws {
    }
    
    func getUsers(withRole role: UserRole?) async throws -> [UserProfile] {
        let users = try loadJSONData(fromFileNamed: "users") as [UserProfile]
        return users
    }
}
