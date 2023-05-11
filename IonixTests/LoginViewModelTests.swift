//
//  LoginViewModelTests.swift
//  IonixTests
//
//  Created by luis on 10/05/23.
//

import Foundation
import XCTest
@testable import Ionix

class TaskViewModelTests: XCTestCase {
    
    var taskViewModel: TaskViewModel!
    let user = UserProfile(id: 0, username: "", email: "", role: .executor, token: "")
    
    override func setUp() {
        super.setUp()
        taskViewModel = TaskViewModel(taskService:  MockedRemoteTaskService())
    }
    
    func testLoadTasks() async {
        let tasks = await taskViewModel.loadTasks()

        XCTAssertEqual(tasks.count, 3)
    }
    
    func testLoadUsers() async {
        let users = await taskViewModel.loadUsers()
        
        XCTAssert(users.count == 5, "Expected 5 users, but got \(users.count)")
    }
    
    func testAddTask() async {
        do {
            let task = try taskViewModel.addTask(title: "test", description: "desc", dueDate: Date(), assignedTo: user, status: TaskStatus.assigned)
            XCTAssert(task.id == taskViewModel.tasks.count, "Expected task id to be \(taskViewModel.tasks.count), but got \(task.id)")
            XCTAssert(taskViewModel.tasks.contains(task), "Expected task to be added to the task list")
        }catch {
            XCTAssert(false, error.localizedDescription.description)
        }
        
    }
    
    func testAddTaskToAdmin() async {
        let user = UserProfile(id: 0, username: "", email: "", role: .admin, token: "")
        
        do {
            let task = try taskViewModel.addTask(title: "test", description: "desc", dueDate: Date(), assignedTo: user, status: TaskStatus.assigned)
            XCTAssertFalse(task.id == taskViewModel.tasks.count, "Expected task id to be \(taskViewModel.tasks.count), but got \(task.id)")
            XCTAssertFalse(taskViewModel.tasks.contains(task), "Expected task to be added to the task list")
        }catch {
            XCTAssertNotNil(error)
        }
        
    }
    
    func testUpdateTask() async {
        await taskViewModel.loadTasks()
        guard let task = taskViewModel.tasks.first else {
            return
        }
        task.status = TaskStatus.doneWithError
        taskViewModel.updateTask(task)
        guard let updatedTask = taskViewModel.tasks.first(where: { $0.id == task.id }) else {
            XCTFail("Expected task to be updated")
            return
        }
        XCTAssert(updatedTask.status == .doneWithError, "Expected task status to be 'doneWithError', but got \(updatedTask.status.rawValue)")
    }
}

