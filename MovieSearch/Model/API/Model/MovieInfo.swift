//
//  MovieInfo.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation

/// protocol for displaying movie info
protocol MovieInfo {
    var id: String? { get }
    var title: String? { get }
    var movieDescription: String? { get }
    var poster: String? { get }
    var isFavorite: Bool { get set }
    var isHidden: Bool { get set }
    var ratingImdb: String? { get }
    var ratingMetacritic: String? { get }
    var ratingMovieDb: String? { get }
}

extension MovieEntity: MovieInfo {}

extension Movie: MovieInfo {
    var isHidden: Bool {
        get {
            hidden ?? false
        }
        set {
            hidden = newValue
        }
    }
    var isFavorite: Bool {
        get {
            favorite ?? false
        }
        set {
            favorite = newValue
        }
    }
    var movieDescription: String? {
        description
    }
    var poster: String? {
        image
    }
    var ratingImdb: String? {
        nil
    }
    var ratingMetacritic: String? {
        nil
    }
    var ratingMovieDb: String? {
        nil
    }
}

extension MovieDetails: MovieInfo {
    var isHidden: Bool {
        get {
            hidden ?? false
        }
        set {
            hidden = newValue
        }
    }
    var isFavorite: Bool {
        get {
            favorite ?? false
        }
        set {
            favorite = newValue
        }
    }
    var movieDescription: String? {
        plot
    }
    var poster: String? {
        posters?.posters?.first?.link ?? image
    }
    var ratingImdb: String? {
        ratings?.imDb
    }
    var ratingMetacritic: String? {
        ratings?.metacritic
    }
    var ratingMovieDb: String? {
        ratings?.theMovieDb
    }
}
