//
//  NewsViewController.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import UIKit

class NewsViewController: UIViewController, UIScrollViewDelegate {
    var viewModel: TableViewModel.ViewModelType.News? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var infoBackground: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var contentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var titleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateView: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var authorView: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .brown
        label.layer.cornerRadius = 8
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.masksToBounds = true
        //label.textColor = .lightGray
        return label
    }()
    
    lazy var contentTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return contentView
    }()
    
    enum BackgroundConstraints {
        case leftAnchor
        case rightAnchor
        case topAnchor
        case bottomAnchor
        
        var value: CGFloat {
            switch self {
            case .leftAnchor:
                return 16
            case .rightAnchor:
                return -16
            case.bottomAnchor:
                return -8
            case .topAnchor:
                return 8
            }
        }
    }
    
    enum ContentConstraints {
        case leftAnchor
        case rightAnchor
        case topAnchor
        case bottomAnchor
        
        var value: CGFloat {
            switch self {
            case .leftAnchor:
                return 8
            case .rightAnchor:
                return -8
            case.bottomAnchor:
                return -8
            case .topAnchor:
                return 8
            }
        }
    }

    
    private func updateUI() {
        guard let viewModel else { return }
        if let title = viewModel.title {
            titleLabel.text = title
        }
        
        if let author = viewModel.author {
            authorView.text = author
        }
        
        if let content = viewModel.content {
            contentTextView.text = content
        }
        
        if let date = viewModel.publishedAt {
            dateView.text = date
        }
        
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(titleBackground)
        titleBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: BackgroundConstraints.topAnchor.value),
            titleBackground.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: BackgroundConstraints.leftAnchor.value),
            titleBackground.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: BackgroundConstraints.rightAnchor.value)
        ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleBackground.topAnchor, constant: BackgroundConstraints.topAnchor.value),
            titleLabel.leftAnchor.constraint(equalTo: titleBackground.leftAnchor, constant: BackgroundConstraints.leftAnchor.value),
            titleLabel.rightAnchor.constraint(equalTo: titleBackground.rightAnchor, constant: BackgroundConstraints.rightAnchor.value),
            titleLabel.bottomAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: BackgroundConstraints.bottomAnchor.value)
        ])
        
        contentView.addSubview(infoBackground)
        infoBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoBackground.topAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: BackgroundConstraints.topAnchor.value),
            infoBackground.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: BackgroundConstraints.leftAnchor.value),
            infoBackground.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: BackgroundConstraints.rightAnchor.value)
        ])
        
        contentView.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: infoBackground.topAnchor, constant: ContentConstraints.topAnchor.value),
            dateView.leftAnchor.constraint(equalTo: infoBackground.leftAnchor, constant: ContentConstraints.leftAnchor.value),
            dateView.rightAnchor.constraint(equalTo: infoBackground.rightAnchor, constant: ContentConstraints.rightAnchor.value)
        ])
        
        contentView.addSubview(authorView)
        authorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: ContentConstraints.topAnchor.value),
            authorView.leftAnchor.constraint(equalTo: infoBackground.leftAnchor, constant: ContentConstraints.leftAnchor.value),
            authorView.rightAnchor.constraint(equalTo: infoBackground.rightAnchor, constant: ContentConstraints.rightAnchor.value),
            authorView.bottomAnchor.constraint(equalTo: infoBackground.bottomAnchor, constant: ContentConstraints.bottomAnchor.value),
        ])
        
        contentView.addSubview(contentBackground)
        contentBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentBackground.topAnchor.constraint(equalTo: infoBackground.bottomAnchor, constant: BackgroundConstraints.topAnchor.value),
            contentBackground.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: BackgroundConstraints.leftAnchor.value),
            contentBackground.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: BackgroundConstraints.rightAnchor.value),
            contentBackground.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: BackgroundConstraints.bottomAnchor.value)
        ])
        
        contentView.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: contentBackground.topAnchor, constant: ContentConstraints.topAnchor.value),
            contentTextView.leftAnchor.constraint(equalTo: contentBackground.leftAnchor, constant: ContentConstraints.leftAnchor.value),
            contentTextView.rightAnchor.constraint(equalTo: contentBackground.rightAnchor, constant: ContentConstraints.rightAnchor.value),
            contentTextView.bottomAnchor.constraint(equalTo: contentBackground.bottomAnchor, constant: ContentConstraints.bottomAnchor.value),
        ])
        
    }
}
