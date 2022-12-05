//
//  RestClient.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

class RestClient {

    static private let baseURL = Configuration.apiBaseUrl.hasSuffix("/") ? Configuration.apiBaseUrl : Configuration.apiBaseUrl+"/"

    /// json call shortcut
    ///
    /// - Parameters:
    ///   - method: request method
    ///   - url: relative url
    ///   - parameters: parameters
    ///   - encoding: parameters encoding
    ///   - headers: additional headers
    /// - Returns: request observable
    static func json<T: Decodable>(_ method: HTTPMethod,
                                   _ url: URLConvertible,
                                   parameters: [String: Any]? = nil,
                                   encoding: ParameterEncoding = URLEncoding.default,
                                   headers: HTTPHeaders? = nil,
                                   addAuthHeader: Bool = true
    )
    -> Observable<T>
    {
        let headers = headers ?? [:]

        return RxAlamofire
            .request(method, "\(baseURL)\(url)", parameters: parameters, encoding: encoding, headers: headers)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .default)) // process everything in background
            .responseData()
            .map {
                $0.1
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .restSend()
    }

}
