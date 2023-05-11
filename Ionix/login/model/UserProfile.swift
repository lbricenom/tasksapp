//
//  user_model.swift
//  Ionix
//
//  Created by luis on 11/05/23.
//

import Foundation

enum UserRole: String, Codable {
    case admin
    case executor

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let roleString = try container.decode(String.self)
        switch roleString {
        case "admin":
            self = .admin
        case "executor":
            self = .executor
        default:
            self = .executor
        }
    }
}
struct UserProfile: Codable, Identifiable, Equatable {
    let id: Int
    let username: String
    let email: String
    let role: UserRole
    let token: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case role
        case token
    }

    init(id: Int, username: String, email: String, role: UserRole, token: String?) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
        self.token = token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        let roleString = try container.decode(String.self, forKey: .role)
        if let role = UserRole(rawValue: roleString) {
            self.role = role
        } else {
            throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid user role value")
        }
        token = try container.decodeIfPresent(String.self, forKey: .token)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(role.rawValue, forKey: .role)
        try container.encodeIfPresent(token, forKey: .token)
    }
}
