//
//  UIViewController+instantiate.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import UIKit

/// instantate from storyboard
extension UIViewController {
    class func instantiate() -> Self {
        UIStoryboard.main.instantiateViewController(withIdentifier: className) as! Self
    }
}
extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
