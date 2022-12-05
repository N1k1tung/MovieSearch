//
//  MovieDetailsViewController.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import AlamofireImage
import RxBinding

final class MovieDetailsViewController: UIViewController {

    // UI
    @IBOutlet private weak var posterView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var hideButton: UIButton!
    @IBOutlet private weak var imdbRatingLabel: UILabel!
    @IBOutlet private weak var movieDbRatingLabel: UILabel!
    @IBOutlet private weak var metacriticRatingLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    var viewModel: MovieDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        viewModel.loadData()
    }

    private func setupBindings() {
        rx.bind {
            favoriteButton.rx.tap ~> viewModel.favoriteTapped
            hideButton.rx.tap ~> viewModel.hideTapped

            viewModel.$error.flatten() ~> { [weak self] in self?.showAlert($0) }
            viewModel.$movie ~> { [weak self] in self?.updateUI(item: $0) }
            viewModel.$isLoading ~> loadingIndicator.rx.isAnimating
        }
    }

    private func updateUI(item: MovieInfo) {
        navigationItem.title = String((item.title ?? "").prefix(20))
        titleLabel.text = item.title
        descriptionLabel.text = item.movieDescription
        favoriteButton.isSelected = item.isFavorite
        hideButton.isSelected = item.isHidden
        if let imageUrl = item.poster, let url = URL(string: imageUrl) {
            posterView.af.setImage(withURL: url)
        }
        imdbRatingLabel.text = item.ratingImdb.ratingString
        movieDbRatingLabel.text = item.ratingMovieDb.ratingString
        metacriticRatingLabel.text = item.ratingMetacritic.ratingString
    }

}
