//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import SkeletonView

final class MovieCell: UITableViewCell, ShowsSkeletonLoading {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!

    var skeletonableItems: [UIView] {
        [posterView, titleLabel, descriptionLabel, favoriteButton, hideButton]
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        favoriteButton.isHiddenWhenSkeletonIsActive = true
        hideButton.isHiddenWhenSkeletonIsActive = true
    }

}
