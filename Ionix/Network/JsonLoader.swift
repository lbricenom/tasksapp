//
//  JsonLoader.swift
//  Ionix
//
//  Created by luis on 10/05/23.
//

import Foundation
protocol JSONLoader {
    func loadJSONData<T: Decodable>(fromFileNamed filename: String) throws -> T
}

extension JSONLoader {
    func loadJSONData<T: Decodable>(fromFileNamed filename: String) throws -> T {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            throw TaskServiceError.invalidData
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
