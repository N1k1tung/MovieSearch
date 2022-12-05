//
//  OfflineView.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit
import RxSwift
import NSObject_Rx

/// tracks offline status and displays offline panel
final class OfflineNavigationController: UINavigationController {

    private enum Constants {
        static let offlineViewHeight: CGFloat = 44
        static let offlineViewAnimationDuration: TimeInterval = 0.3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOfflineView()
    }

    private var viewModel = OfflineViewModel()

    private func setupOfflineView() {
        let offlineView = UIView(frame: .zero)
        offlineView.translatesAutoresizingMaskIntoConstraints = false
        offlineView.backgroundColor = .systemGray
        offlineView.alpha = 0

        view.addSubview(offlineView)
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 12)
        label.text = "Internet appears to be offline"
        offlineView.addSubview(label)

        let offlineViewOffset = offlineView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: Constants.offlineViewHeight
        )

        NSLayoutConstraint.activate([
            offlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineView.heightAnchor.constraint(equalToConstant: Constants.offlineViewHeight),
            offlineViewOffset,
            label.centerXAnchor.constraint(equalTo: offlineView.centerXAnchor),
            label.topAnchor.constraint(equalTo: offlineView.topAnchor, constant: 8),
        ])

        // track state changes and show / hide
        viewModel.$isOnline
            .debounce(.milliseconds(Int(Constants.offlineViewAnimationDuration*1000)), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self, weak offlineView, weak offlineViewOffset] hide in
                guard let self, let offlineView else { return }

                if !hide {
                    offlineView.isHidden = false
                }

                offlineViewOffset?.constant = hide ? Constants.offlineViewHeight : 0

                UIView.animate(withDuration: Constants.offlineViewAnimationDuration,
                               delay: 0,
                               animations: {
                    offlineView.alpha = hide ? 0 : 1
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    if hide {
                        offlineView.isHidden = true
                    }
                })
            })
            .disposed(by: rx.disposeBag)
    }

}
