//
//  FoundationExt.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation

/// allows throwing strings
extension String: Error {}

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

extension NSObject {
    static var className: String {
        String(describing: self)
    }
    var className: String {
        String(describing: type(of: self))
    }
}
