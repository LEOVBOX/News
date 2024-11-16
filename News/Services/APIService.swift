//
//  APIService.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import Foundation
import Combine

class APIService: APIServiceProtocol {
    func fetchResponse(from url: URL) -> AnyPublisher<Response, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<Response, Error> in
                print("Ошибка декодирования: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

}
