//
//  DetailsRepo.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxSwift

protocol DetailsRepo {
    func titleDetails(id: String) -> Observable<MovieDetails>
}

final class DetailsRepoImpl: DetailsRepo {
    func titleDetails(id: String) -> Observable<MovieDetails> {
        RestClient.json(.get, "Title/\(Configuration.apiKey)/\(id)/Posters,Ratings")
    }
}

protocol InjectDetailsRepo {
    var detailsRepo: DetailsRepo { get }
}

extension InjectDetailsRepo {
    var detailsRepo: DetailsRepo {
        DetailsRepoImpl()
    }
}
