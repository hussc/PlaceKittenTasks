//
//  KittensDataSource.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import Foundation

struct Kitten: Hashable, Identifiable {
    let imageURL: URL
    
    var id: String { imageURL.absoluteString }
}

protocol KittensDataSourceProtocol {
    func fetchKittens() async throws -> [Kitten]
    
    func fetchOneAwesomeKitten() async throws -> Kitten
}

struct DefaultKittensDataSource: KittensDataSourceProtocol {
    func fetchKittens() async throws -> [Kitten] {
        try await Task.sleep(for: .seconds(2))
        return (1...10).compactMap { URL(string: "https://placekitten.com/500/\(500 + $0 * 20)") }.map {
            Kitten(imageURL: $0)
        }
    }
    
    func fetchOneAwesomeKitten() async throws -> Kitten {
        try await Task.sleep(for: .seconds(2))
        return Kitten(imageURL: URL(string: "https://placekitten.com/1000/1000")!)
    }
}
