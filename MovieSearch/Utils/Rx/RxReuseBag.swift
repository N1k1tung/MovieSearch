//
//  RxReuseBag.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import RxCocoa
import RxSwift
import RxBinding

private var prepareForReuseBag: Int8 = 0

@objc public protocol Reusable : AnyObject {
    func prepareForReuse()
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}

/// dispose bag that cleans up upon prepare for reuse call
extension Reactive where Base: Reusable {

    var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(Base.prepareForReuse)).map { _ in }, deallocated).merge()
    }

    var reuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()

        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }

        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

        _ = sentMessage(#selector(Base.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                guard let base = base else { return }
                let newBag = DisposeBag()
                objc_setAssociatedObject(base, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })

        return bag
    }
}

extension Reactive where Base: Reusable {

    func bindUntilReuse(@BindingsBuilder _ bindings: () -> [Disposable]) {
        bindings().forEach { $0.disposed(by: reuseBag) }
    }

}
