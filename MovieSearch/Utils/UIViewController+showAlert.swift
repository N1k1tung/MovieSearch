//
//  UIViewController+showAlert.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit

// shows alert with single OK action
extension UIViewController {
    func showAlert(_ message: String, title: String = "", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alert, animated: true, completion: nil)
    }
}
