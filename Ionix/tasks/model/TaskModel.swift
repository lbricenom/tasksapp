//
//  TaskModel.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation

enum TaskStatus: String, Codable {
    case new
    case assigned
    case inprogress = "In Progress"
    case waiting
    case doneWithError = "Done with errors"
    case doneSuccessfully = "Done"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        case "new":
            self = .new
        case "assigned":
            self = .assigned
        case "In Progress":
            self = .inprogress
        case "waiting":
            self = .waiting
        case "Done with errors":
            self = .doneWithError
        case "Done":
            self = .doneSuccessfully
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid task status: \(rawValue)")
        }
    }
}

class TaskModel: Identifiable, Codable, Equatable, ObservableObject, Hashable {
    
    let id: Int
    var title: String
    var description: String
    var dueDate: Date
    var assignedTo: UserProfile?
    var status: TaskStatus
    var comments: [String]?
    
    init(id: Int, title: String, description: String, dueDate: Date, assignedTo: UserProfile?, status: TaskStatus, comments: [String] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.assignedTo = assignedTo
        self.status = status
        self.comments = comments
    }
    
    func canUpdateOrDelete(userProfile: UserProfile?) -> Bool {
        guard let currentUser = userProfile,
              assignedTo == nil,
              status != TaskStatus.assigned else {
            return false
        }
        return currentUser.role == .admin
    }
    
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dueDate
        case assignedTo
        case status
        case comments
    }
    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        assignedTo = try container.decodeIfPresent(UserProfile.self, forKey: .assignedTo)
        let statusString = try container.decode(String.self, forKey: .status)
        status = TaskStatus(rawValue: statusString) ?? .new
        comments = try container.decodeIfPresent([String].self, forKey: .comments)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(comments, forKey: .comments)
    }
}

