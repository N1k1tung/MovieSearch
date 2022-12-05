//
//  FlowCoordinator.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit

/// simple navigation coordinator for UIKit
protocol FlowCoordinator {
    var rootViewController: UIViewController { get }
}

final class AppCoordinator: FlowCoordinator {
    var rootViewController: UIViewController {
        MovieSearchCoordinator().rootViewController
    }
}

