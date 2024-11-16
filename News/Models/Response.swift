//
//  News.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import Foundation
import Combine

struct Response: Codable {
    struct Article: Codable {
        struct Source: Codable {
            let id: String?
            let name: String?
        }
        
        let source: Source?
        let author: String?
        let title: String?
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: String?
        let content: String?
    }
    
    
    let status: String?
    let totalResults: Int?
    let articles: [Article]?

}
