//
//  MovieSearchViewModel.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxSwift
import NSObject_Rx
import RxCoreData

final class MovieSearchViewModel: HasDisposeBag, InjectSearchRepo, InjectDatabase {

    // MARK: navigation
    enum NavigationEvent {
        case didSelectMovie(any MovieInfo)
    }
    private let eventHandler: (NavigationEvent) -> Void

    init(eventHandler: @escaping (NavigationEvent) -> Void) {
        self.eventHandler = eventHandler

        setupSearch()
        setupFavorites()
        setupHidden()
    }

    // MARK: inputs/outputs
    @RxPublished var searchText = ""
    @RxPublished private(set) var error: String?
    @RxPublished private(set) var noResultsText: String?
    @RxPublished private(set) var displayedMovies: [any MovieInfo] = []
    private var favoriteMovies: [MovieEntity] = []
    private var hiddenMovies = Set<String>()
    private var forceReload = PublishSubject<String>()

    // MARK: actions
    func willDismissSearch() {
        searchText = ""
    }

    func didSelect(movie: any MovieInfo) {
        eventHandler(.didSelectMovie(movie))
    }

    func didFavorite(index: Int) {
        displayedMovies[index].isFavorite.toggle()
        let movie = displayedMovies[index]
        database.write { context in
            MovieEntity.upsert(info: movie, in: context)
        }
    }

    func didHide(index: Int) {
        displayedMovies[index].isHidden.toggle()
        let movie = displayedMovies[index]
        database.write { context in
            MovieEntity.upsert(info: movie, in: context)
        }
    }

    func reloadData() {
        forceReload.on(.next(searchText))
    }

    // MARK: private
    private func setupSearch() {
        let search = $searchText
            .map { $0.trimmed.lowercased() }
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(600), scheduler: MainScheduler.instance)
        Observable.merge(search, forceReload)
            .flatMap { [weak self] in
                guard let self else { return Observable<SearchResponse>.empty() }
                self.noResultsText = nil
                self.displayedMovies = Array(repeating: Movie.loading, count: 8)
                return self.searchRepo.searchTitles(query: $0).asObservable()
            }
            .subscribe(onNext: { [weak self] in
                self?.filterResults(movies: $0.results ?? [])
            }, onError: { [weak self] in
                self?.filterResults(movies: [])
                self?.error = $0.localizedDescription
            })
            .disposed(by: disposeBag)
    }

    private func filterResults(movies: [Movie]) {
        displayedMovies = movies.filter { !hiddenMovies.contains($0.id ?? "") }
        updateFavoriteOnDisplayed()
        noResultsText = displayedMovies.isEmpty ? "No Results" : nil
    }

    private func setupFavorites() {
        let fetch = MovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: "isFavorite = YES")
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        database.viewContext.rx
            .entities(fetchRequest: fetch)
            .subscribe(onNext: { [weak self] in
                self?.favoriteMovies = $0
                self?.updateFavoriteOnDisplayed()
            })
            .disposed(by: disposeBag)

        $searchText
            .map { $0.trimmed }
            .filter { $0.isEmpty }
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.displayedMovies = self.favoriteMovies
                self.noResultsText = self.displayedMovies.isEmpty ? "No Favourites" : nil
            })
            .disposed(by: disposeBag)
    }

    private func updateFavoriteOnDisplayed() {
        guard !searchText.isEmpty else { return }
        let favoriteIds = Set(favoriteMovies.compactMap { $0.id })
        for i in displayedMovies.indices {
            displayedMovies[i].isFavorite = favoriteIds.contains(displayedMovies[i].id ?? "")
        }
    }

    private func setupHidden() {
        let fetch = MovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: "isHidden = YES")
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetch.propertiesToFetch = ["id"]
        database.viewContext.rx
            .entities(fetchRequest: fetch)
            .map { $0.compactMap { $0.id } }
            .subscribe(onNext: { [weak self] in
                self?.hiddenMovies = Set($0)
                self?.updateHiddenOnDisplayed()
            })
            .disposed(by: disposeBag)
    }

    private func updateHiddenOnDisplayed() {
        guard !searchText.isEmpty else { return }
        for i in displayedMovies.indices {
            displayedMovies[i].isHidden = hiddenMovies.contains(displayedMovies[i].id ?? "")
        }
    }

}
