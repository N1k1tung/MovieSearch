//
//  MovieEntitity+ext.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 5.12.22.
//

import Foundation
import CoreData

extension MovieEntity {

    /// update or create object for id
    class func object(id: String, in context: NSManagedObjectContext) -> MovieEntity {
        let fetch = MovieEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        let result = try? context.fetch(fetch)
        return result?.first ?? MovieEntity(context: context)
    }

    @discardableResult
    class func upsert(info: MovieInfo, in context: NSManagedObjectContext) -> MovieEntity? {
        guard let id = info.id else { return nil }
        let entity = object(id: id, in: context)
        entity.id = id
        entity.isHidden = info.isHidden
        entity.isFavorite = info.isFavorite
        entity.poster = info.poster
        entity.movieDescription = info.movieDescription
        entity.title = info.title
        entity.ratingImdb = info.ratingImdb
        entity.ratingMetacritic = info.ratingMetacritic
        entity.ratingMovieDb = info.ratingMovieDb
        return entity
    }

}
