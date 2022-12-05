//
//  ObservableType+ext.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxSwift

extension ObservableType {
    /// wrap remote call in shareReplay & observe on main thread
    func restSend() -> Observable<Element> {
        subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
    }

    /// discard result type
    func toVoid() -> Observable<Void> {
        self.map { _ in }
    }

}
