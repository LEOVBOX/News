//
//  NewsTableViewCell.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.News? {
        didSet {
            updateUI()
        }
    }
    
    lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.layer.cornerRadius = 8
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var dateView: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .blue
        label.layer.cornerRadius = 8
        label.font = UIFont.systemFont(ofSize: 12)
        //label.layer.masksToBounds = true
        return label
    }()

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        guard let viewModel else { return }
        if let title = viewModel.title {
            titleView.text = title
        }
        
        
        if let date = viewModel.publishedAt {
            dateView.text = date
        }
        
    }
    
    enum BackgourndConstraints {
        case leftAnchor
        case rightAnchor
        case topAnchor
        case bottomAnchor
        case heightAnchor
        
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
            case .heightAnchor:
                return 20
            }
        }
    }
    
    enum TitleViewConstraints {
        case topAnchor
        case leftAnchor
        case rightAnchor
        
        var value: CGFloat {
            switch self {
            case .topAnchor:
                return 4
            case .leftAnchor:
                return 4
            case .rightAnchor:
                return -4
            }
            
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BackgourndConstraints.topAnchor.value),
            background.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BackgourndConstraints.leftAnchor.value),
            background.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BackgourndConstraints.rightAnchor.value),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: BackgourndConstraints.bottomAnchor.value)
        ])
        
        background.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: background.topAnchor, constant: TitleViewConstraints.topAnchor.value),
            titleView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            titleView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: TitleViewConstraints.rightAnchor.value),
            titleView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: TitleViewConstraints.leftAnchor.value)
        ])
        
//        background.addSubview(authorView)
//        authorView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            authorView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 4),
//            authorView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -4),
//            authorView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 4),
//            
//            
//        ])
        
        background.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 4),
            dateView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -4),
            dateView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 4),
            dateView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -4)
        ])
        
//        background.addSubview(contentTextView)
//        contentTextView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentTextView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -4),
//            contentTextView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 4),
//            contentTextView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 4),
//            contentTextView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -4)
//        ])
        
        //contentView.addSubview(<#T##view: UIView##UIView#>)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}
