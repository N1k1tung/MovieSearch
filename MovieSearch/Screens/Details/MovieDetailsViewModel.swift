//
//  MovieDetailsViewModel.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxSwift
import NSObject_Rx

final class MovieDetailsViewModel: HasDisposeBag, InjectDetailsRepo, InjectDatabase {

    // MARK: navigation
    enum NavigationEvent {
        case didClose
    }
    private let eventHandler: (NavigationEvent) -> Void

    init(movie: any MovieInfo, eventHandler: @escaping (NavigationEvent) -> Void) {
        self.eventHandler = eventHandler
        self.movie = movie
    }

    // MARK: inputs/outputs
    @RxPublished private(set) var movie: any MovieInfo
    @RxPublished private(set) var error: String?
    @RxPublished private(set) var isLoading = false

    // MARK: actions
    func loadData() {
        guard let id = movie.id else { return }
        isLoading = true
        detailsRepo.titleDetails(id: id)
            .subscribe(onNext: { [weak self] in
                self?.update(movie: $0)
                self?.isLoading = false
            }, onError: { [weak self] in
                print($0)
                self?.error = $0.localizedDescription
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }

    func hideTapped() {
        movie.isHidden.toggle()
        database.write { context in
            MovieEntity.upsert(info: self.movie, in: context)
        }
    }

    func favoriteTapped() {
        movie.isFavorite.toggle()
        database.write { context in
            MovieEntity.upsert(info: self.movie, in: context)
        }
    }

    // MARK: private
    private func update(movie: MovieDetails) {
        var new = movie as MovieInfo
        new.isHidden = self.movie.isHidden
        new.isFavorite = self.movie.isFavorite
        self.movie = new
        if new.isFavorite { // update stored info if user favorited the item before
            database.write { context in
                MovieEntity.upsert(info: new, in: context)
            }
        }
    }

}

extension Optional where Wrapped == String {

    var ratingString: String {
        self?.nilIfEmpty ?? "N/A"
    }

}
