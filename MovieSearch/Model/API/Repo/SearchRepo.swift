//
//  SearchRepo.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxSwift

protocol SearchRepo {
    func searchTitles(query: String) -> Observable<SearchResponse>
}

final class SearchRepoImpl: SearchRepo {
    func searchTitles(query: String) -> Observable<SearchResponse> {
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query
        return RestClient.json(.get, "SearchMovie/\(Configuration.apiKey)/\(query)")
    }
}

protocol InjectSearchRepo {
    var searchRepo: SearchRepo { get }
}

extension InjectSearchRepo {
    var searchRepo: SearchRepo {
        SearchRepoImpl()
    }
}
