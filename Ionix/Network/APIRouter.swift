//
//  APIRouter.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import Alamofire

 enum APIRouter: URLRequestConvertible {
    static let baseURLString = "https://api.example.com"
    
    case login(username: String, password: String)
    case logout
    case getTasks
    case addTask(title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus)
    case assignTask(task: TaskModel, user: UserProfile)
    case updateTask(task: TaskModel)
    case deleteTask(task: TaskModel)
    case getUsers(role: UserRole?)
    case forgotPassword(username: String)
    
    var method: HTTPMethod {
        switch self {
        case .login, .addTask, .forgotPassword:
            return .post
        case .logout, .deleteTask:
            return .delete
        case .assignTask, .updateTask:
            return .put
        case .getTasks, .getUsers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .logout:
            return "/auth/logout"
        case .getTasks, .addTask:
            return "/tasks"
        case .assignTask(let task, _), .updateTask(let task), .deleteTask(let task):
            return "/tasks/\(task.id)"
        case .getUsers:
            return "/users"
        case .forgotPassword:
            return "/auth/forgot_password"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [
                "username": username,
                "password": password
            ]
        case  .forgotPassword(let username):
            return [
                "username": username,
            ]
        case .getTasks, .logout, .deleteTask, .assignTask, .updateTask, .getUsers:
            return nil
        case .addTask(let title, let description, let dueDate, let assignedTo, let status):
            var params: [String: Any] = [
                "title": title,
                "description": description,
                "due_date": dueDate.iso8601,
                "status": status.rawValue
            ]
            if let user = assignedTo {
                params["assigned_to"] = [
                    "id": user.id,
                    "name": user.username,
                    "email": user.email,
                    "role": user.role.rawValue
                ]
            }
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .login, .addTask, .forgotPassword:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .logout, .getTasks, .assignTask, .updateTask, .deleteTask, .getUsers:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
