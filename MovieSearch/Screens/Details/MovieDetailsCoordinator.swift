//
//  MovieDetailsCoordinator.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit

final class MovieDetailsCoordinator: FlowCoordinator {

    private let movie: any MovieInfo

    init(movie: any MovieInfo) {
        self.movie = movie
    }

    var rootViewController: UIViewController {
        detailsViewController()
    }

    private func detailsViewController() -> UIViewController {
        let viewContoller = MovieDetailsViewController.instantiate()
        viewContoller.viewModel = MovieDetailsViewModel(movie: movie) { [weak viewContoller] in
            switch $0 {
            case .didClose:
                viewContoller?.navigationController?.popViewController(animated: true)
            }
        }
        return viewContoller
    }

}
