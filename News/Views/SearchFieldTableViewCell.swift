//
//  SearchFieldTableViewCell.swift
//  News
//
//  Created by Леонид Шайхутдинов on 16.11.2024.
//

import UIKit
import Combine

class SearchFieldTableViewCell: UITableViewCell {
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: TableViewModel.ViewModelType.SearchField? {
        didSet {
            updateUI()
        }
    }
    
    lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Найти новость"
        return textField
    }()
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        if let text = viewModel.text {
            textField.text = text
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
    
    enum TextFieldConstraints {
        case topAnchor
        case rightAnchor
        case leftAnchor
        case bottomAnchor
        
        var value: CGFloat {
            switch self {
            case .leftAnchor:
                return 8
            case .rightAnchor:
                return -8
            case .bottomAnchor:
                return -8
            case .topAnchor:
                return 8
            }
            
        }
    }
    
    private func setupUI() {
        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: BackgourndConstraints.topAnchor.value),
            background.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: BackgourndConstraints.leftAnchor.value),
            background.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: BackgourndConstraints.rightAnchor.value),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: BackgourndConstraints.bottomAnchor.value),
            //background.heightAnchor.constraint(equalToConstant: BackgourndConstraints.heightAnchor.value)
        ])
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: background.topAnchor, constant: TextFieldConstraints.topAnchor.value),
            textField.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: TextFieldConstraints.bottomAnchor.value),
            textField.leftAnchor.constraint(equalTo: background.leftAnchor, constant: TextFieldConstraints.leftAnchor.value),
            textField.rightAnchor.constraint(equalTo: background.rightAnchor, constant: TextFieldConstraints.rightAnchor.value)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}
