//
//  NetworkExtension.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
import Alamofire

protocol NetworkRequestable {
    func makeDecodableRequest<T: Decodable>(for endpoint: APIRouter) async throws -> T
    func makeRequest(for endpoint: APIRouter) async throws
}

extension NetworkRequestable {
    func makeDecodableRequest<T: Decodable>(for endpoint: APIRouter) async throws -> T {
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(endpoint).validate().responseDecodable(of: T.self) { response in
                if let data = response.value {
                    continuation.resume(returning: data)
                    return
                }
                if let err = response.error {
                    continuation.resume(throwing: err)
                    return
                }
            }
        }
    }
    
    func makeRequest(for endpoint: APIRouter) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(endpoint).validate().response { response in
                if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
