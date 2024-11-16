//
//  APIServiceProtocol.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetchResponse(from url: URL) -> AnyPublisher<Response, Error>
}
