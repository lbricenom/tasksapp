//
//  ServiceLocator.swift
//  Ionix
//
//  Created by luis on 9/05/23.
//

import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()

    private var services = [String: Any]()

    func register<T>(_ service: T) {
        let key = "\(T.self)"
        services[key] = service
    }

    func resolve<T>() -> T {
        let key = "\(T.self)"
        guard let service = services[key] as? T else {
            fatalError("Service \(key) not registered")
        }
        return service
    }
}
