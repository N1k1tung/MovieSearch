//
//  UIView+skeletonable.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import SkeletonView

protocol ShowsSkeletonLoading {
    var skeletonableItems: [UIView] { get }

    func addLoader()
    func removeLoader()
}

extension ShowsSkeletonLoading {

    func addLoader() {
        skeletonableItems.forEach {
            $0.sizeToFit()
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = 4
            $0.showAnimatedGradientSkeleton()
        }
    }

    func removeLoader() {
        skeletonableItems.forEach {
            $0.hideSkeleton()
        }
    }

}
