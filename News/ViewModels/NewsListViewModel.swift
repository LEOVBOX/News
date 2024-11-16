//
//  NewsListViewModel.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import Foundation
import Combine

class NewsListViewModel {
    let API_KEY = "aa6975ae67014a4d927b0e80c5c9b7bc"
    // Опубликованные свойства для привязки к View
    @Published var cellsViewModels: [TableViewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var lastQuery = ""
    private var currentPage: Int {
        self.cellsViewModels.count / pageSize
    }
    private let pageSize = 20
    

    // Поле поиска как отдельная ViewModel
    lazy var searchFieldViewModel: TableViewModel.ViewModelType.SearchField = {
        TableViewModel.ViewModelType.SearchField(text: nil)
    }()
    
    var queryPublisher: AnyPublisher<String, Never>?

    private var apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        
        guard let queryPublisher else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            queryPublisher.sink(receiveCompletion: {_ in }) { query in
                self.updateSearchQuery(query)
            }.store(in: &self.cancellables)
        }
        
    }

    
    func loadMoreMessages() {
       guard !isLoading else { return }
       isLoading = true

       let url = URL(string: "https://newsapi.org/v2/everything?q=\(lastQuery)&pageSize=\(pageSize)&page=\(currentPage)&apiKey=\(API_KEY)")!

       apiService.fetchResponse(from: url)
           .receive(on: DispatchQueue.main)
           .sink(receiveCompletion: { [weak self] completion in
               self?.isLoading = false
               if case .failure(let error) = completion {
                   print("Error fetching messages: \(error)")
               }
           }, receiveValue: { [weak self] response in
               self?.cellsViewModels.append(contentsOf: self?.handleResponse(response) ?? [])
           })
           .store(in: &cancellables)
       }

    // Метод для обработки изменений в поле поиска
    func updateSearchQuery(_ query: String?) {
        guard let query = query, !query.isEmpty else { return }
        
        lastQuery = query
        
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&pageSize=\(pageSize)&apiKey=\(API_KEY)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Некорректный URL"
            return
        }
        
        fetchData(from: url)
    }

    // Метод для выполнения сетевого запроса
    func fetchData(from url: URL) {
        apiService.fetchResponse(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.cellsViewModels = self?.handleResponse(response) ?? []
            })
            .store(in: &cancellables)
    }
    

    private func handleResponse(_ response: Response) -> [TableViewModel] {
        guard response.status == "ok", let articles = response.articles else {
            errorMessage = "Не удалось загрузить статьи или произошла ошибка"
            return []
        }

        // Проверяем, сколько статей мы получили
        print("Получено \(response.articles?.count ?? 0) статей.")
        
        let newsCells = response.articles?.compactMap { article in
            // Проверяем условие
            guard article.title != "[Removed]" else { return nil }
            
            // Создаем новый элемент
            return TableViewModel(type: .news(.init(
                author: article.author ?? "Неизвестный автор",
                title: article.title ?? "Без заголовка",
                publishedAt: article.publishedAt?.replacingOccurrences(of: "T", with: " ")
                    .replacingOccurrences(of: "Z", with: " ") ?? "Дата неизвестна",
                content: article.content
            )))
        } ?? []
        
        // Проверяем, сколько ячеек мы создали
        print("Создано ячеек: \(newsCells.count)")

        // Обновляем `cellsViewModels`, сохраняя поле поиска
//        cellsViewModels = [
//            cellsViewModels.first
//        ].compactMap { $0 } + newsCells
        return newsCells as? [TableViewModel] ?? []

    }

}

