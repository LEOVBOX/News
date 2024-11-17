//
//  NewsListViewController.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import UIKit
import Combine

class NewsListViewController: UIViewController {
    private let viewModel = NewsListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchFieldView: SearchFieldView = {
        return SearchFieldView()
    }()
    
    private lazy var dateSortCheckbox: CheckboxView = {
        return CheckboxView()
    }()
    
    private lazy var popularitySortCheckbox: CheckboxView = {
        return CheckboxView()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: String(describing: NewsTableViewCell.self))
        tableView.register(SearchFieldTableViewCell.self, forCellReuseIdentifier: String(describing: SearchFieldTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private func bindViewModel() {
        // Подписка на изменения в данных для таблицы
        viewModel.$cellsViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func openNewsView(viewModel: TableViewModel.ViewModelType.News?) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationItem.backButtonTitle = ""
            let vc = NewsViewController()
            vc.viewModel = viewModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    // Подписка на изменения в строке поиска
    private func bindSearchFieldPublisher() {
        searchFieldView.textPublisher
           .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Задержка 300 мс
           .filter { $0.count >= 3 } // Введено более 3х символов
           .removeDuplicates() // Исключение повторяющихся значений
           .sink { [weak self] text in
               self?.viewModel.updateSearchQuery(text)
           }
           .store(in: &cancellables)
    }
    
    private func bindDateCheckboxPublisher() {
        dateSortCheckbox.statePublisher
            .removeDuplicates()
            .sink { [weak self] isDateSorting in
                self?.popularitySortCheckbox.isChecked = !isDateSorting
                self?.viewModel.sortByPublishedAt = isDateSorting
            }.store(in: &cancellables)
    }
    
    private func bindPopularityCheckboxPublisher() {
        popularitySortCheckbox.statePublisher
            .removeDuplicates()
            .sink { [weak self] isPopularitySorting in
                self?.dateSortCheckbox.isChecked = !isPopularitySorting
                self?.viewModel.sortByPublishedAt = !isPopularitySorting
            }.store(in: &cancellables)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "Новости"
        
        view.addSubview(searchFieldView)
        searchFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchFieldView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchFieldView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        view.addSubview(dateSortCheckbox)
        dateSortCheckbox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateSortCheckbox.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
            dateSortCheckbox.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dateSortCheckbox.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        view.addSubview(popularitySortCheckbox)
        popularitySortCheckbox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popularitySortCheckbox.topAnchor.constraint(equalTo: dateSortCheckbox.bottomAnchor),
            popularitySortCheckbox.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            popularitySortCheckbox.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: popularitySortCheckbox.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchFieldView.viewModel = viewModel.searchFieldViewModel
        dateSortCheckbox.viewModel = viewModel.dateCheckboxViewModel
        popularitySortCheckbox.viewModel = viewModel.popularityCheckboxViewModel
        bindSearchFieldPublisher()
        bindDateCheckboxPublisher()
        bindPopularityCheckboxPublisher()
        bindViewModel()
    }
    
    
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellsViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel.cellsViewModels[indexPath.row]
        
        switch viewModel.type {
        case .news(let news):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self)) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = news
            return cell
        case .searchField(let searchField):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchFieldTableViewCell.self)) as? SearchFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = searchField
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let frameHeight = scrollView.frame.size.height

            if offsetY > contentHeight - frameHeight - 100 { // Подгружаем за 100 пикселей до конца
                viewModel.loadMoreMessages()
            }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else {
            return
        }
        let viewModel = cell.viewModel
        openNewsView(viewModel: viewModel)
    }
}
