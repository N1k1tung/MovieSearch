//
//  OfflineViewModel.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import Alamofire

/// tracks reachability status and maps into online state
final class OfflineViewModel {
    @RxPublished var isOnline = true

    private var reachability: NetworkReachabilityManager? = .default

    init() {
        reachability?.startListening { [weak self] in
            self?.isOnline = $0 != .notReachable
        }
    }

    deinit {
        reachability?.stopListening()
    }
}


