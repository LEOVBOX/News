//
//  TableViewModel.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import Foundation
import Combine

struct TableViewModel {
    // ViewModels for table cells
    enum ViewModelType {
        struct News {
            let author: String?
            let title: String?
            let publishedAt: String?
            let content: String?
        }
        
        struct SearchField {
            var text: String? = nil
            var textPublisher: AnyPublisher<String, Never>?
        }
        
        case news(News)
        case searchField(SearchField)
    }
    
    var type: ViewModelType
}
