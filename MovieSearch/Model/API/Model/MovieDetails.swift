//
//  MovieDetails.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation

struct MovieDetails: Codable {
    let id, title: String?
    let originalTitle, fullTitle: String?
    let type, year: String?
    let image: String?
    let runtimeStr, plot: String?
    let plotLocal: String?
    let awards, directors: String?
    let writers: String?
    let stars: String?
    let genres: String?
    let companies: String?
    let countries: String?
    let languages: String?
    let ratings: Ratings?
    let posters: Posters?
    let keywords: String?
    let errorMessage: String?

    // dto
    var favorite: Bool?
    var hidden: Bool?
}

struct Posters: Codable {
    let posters, backdrops: [Image]?
}

struct Image: Codable {
    let id: String
    let link: String?
    let aspectRatio: Double?
    let width, height: Int?
}

struct Ratings: Codable {
    let imDb, metacritic, theMovieDb, rottenTomatoes, filmAffinity: String?
}
