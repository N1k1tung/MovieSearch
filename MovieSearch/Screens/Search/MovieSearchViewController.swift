//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxBinding
import AlamofireImage

final class MovieSearchViewController: UIViewController {

    private enum Constants {
        static let imageSize = CGSize(width: 56, height: 75)
    }

    var viewModel: MovieSearchViewModel!

    // UI
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    private var searchController: UISearchController!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        self.searchController = searchController

        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
    }

    private func setupBindings() {
        rx.bind {
            searchController.rx.willDismiss ~> viewModel.willDismissSearch
            searchController.searchBar.rx.text.flatten() ~> viewModel.$searchText

            tableView.rx.modelSelected(MovieInfo.self) ~> viewModel.didSelect(movie:)
            refreshControl.rx.controlEvent(.valueChanged) ~> viewModel.reloadData
            refreshControl.rx.controlEvent(.valueChanged) ~> { [weak self] in
                self?.refreshControl.endRefreshing()
            }

            viewModel.$error.flatten() ~> { [weak self] in self?.showAlert($0) }
            viewModel.$noResultsText ~> noResultsLabel.rx.text
        }

        viewModel.$displayedMovies
            .bind(to: tableView.rx.items(cellIdentifier: MovieCell.className)) { [weak self] (index, item, cell: MovieCell) in
                guard let self else { return }

                if item.id == Movie.loading.id {
                    cell.addLoader()
                    return
                }
                cell.removeLoader()
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.movieDescription
                cell.favoriteButton.isSelected = item.isFavorite
                cell.hideButton.setTitle(item.isHidden ? "Unhide" : "Hide", for: .normal)
                cell.posterView.image = nil
                if let imageUrl = item.poster, let url = URL(string: imageUrl) {
                    cell.posterView.af.setImage(withURL: url, filter: ScaledToSizeFilter(size: Constants.imageSize))
                }
                if item.ratingImdb != nil || item.ratingMetacritic != nil || item.ratingMovieDb != nil {
                    cell.ratingsLabel.text = "IMDB: \(item.ratingImdb.ratingString) MovDB: \(item.ratingMovieDb.ratingString) Meta: \(item.ratingMetacritic.ratingString)"
                }
                else {
                    cell.ratingsLabel.text = nil
                }
                cell.rx.bindUntilReuse {
                    cell.favoriteButton.rx.tap
                        .map { index } ~> self.viewModel.didFavorite(index:)
                    cell.hideButton.rx.tap
                        .map { index } ~> self.viewModel.didHide(index:)
                }
            }
            .disposed(by: rx.disposeBag)
    }

}
