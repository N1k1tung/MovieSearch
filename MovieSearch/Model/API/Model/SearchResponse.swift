//
//  SearchResponse.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let expression: String?
    let results: [Movie]?
    let errorMessage: String?
}

// MARK: - Movie
struct Movie: Codable {
    let id, title: String?
    let image: String?
    let description: String?

    // dto
    var favorite: Bool?
    var hidden: Bool?

    // loading display
    static var loading = Movie(id: "-1", title: "", image: nil, description: nil)
}
