//
//  MovieSearchCoordinator.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit

final class MovieSearchCoordinator: FlowCoordinator {

    var rootViewController: UIViewController {
        let navigationController = OfflineNavigationController(rootViewController: searchViewController())
        return navigationController
    }

    private func searchViewController() -> UIViewController {
        let searchViewController = MovieSearchViewController.instantiate()
        searchViewController.viewModel = MovieSearchViewModel { [weak searchViewController] in
            switch $0 {
            case .didSelectMovie(let movie):
                let viewController = MovieDetailsCoordinator(movie: movie).rootViewController
                searchViewController?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        return searchViewController
    }

}
