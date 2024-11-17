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
        
        struct Checkbox {
            var isChecked: Bool
            var label: String?
        }
        
        case news(News)
        case searchField(SearchField)
        case checkbox(Checkbox)
    }
    
    var type: ViewModelType
}
