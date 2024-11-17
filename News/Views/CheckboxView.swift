//
//  CheckboxCellView.swift
//  Order
//
//  Created by Леонид Шайхутдинов on 03.11.2024.
//

import UIKit
import Combine

class CheckboxView: UIView {
    var viewModel: TableViewModel.ViewModelType.Checkbox? {
        didSet {
            updateUI()
        }
    }
    
    // Publisher для отслеживания изменений состояния
    private let stateSubject = PassthroughSubject<Bool, Never>()
    var statePublisher: AnyPublisher<Bool, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private lazy var contentView: UIView = {
       return UIView()
    }()
    
    private lazy var trueCheckImage: UIImage = {
        let image = UIImage(named: "true") ?? UIImage()
        return image
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    var isChecked: Bool = false {
        didSet {
            updateCheckboxUI()
            stateSubject.send(isChecked)
        }
    }
    
    private lazy var checkBoxView: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(check), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private func updateCheckboxUI() {
        if (isChecked) {
            self.checkBoxView.layer.borderColor = .none
            self.checkBoxView.backgroundColor = .red
            self.checkBoxView.setImage(trueCheckImage, for: .normal)
        }
        else {
            self.checkBoxView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.checkBoxView.setImage(.none, for: .normal)
            self.checkBoxView.backgroundColor = .none
        }
    }
    
    @objc private func check() {
        isChecked = !isChecked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum MainViewConstraints {
        case topAnchor
        case bottomAnchor
        case leftAnchor
        case rightAnchor
        
        var value: CGFloat {
            switch self {
            case .topAnchor:
                return 8
            case .bottomAnchor:
                return -8
            case .leftAnchor:
                return 16
            case .rightAnchor:
                return -16
            }
        }
    }
    
    enum CheckboxConstraints {
        case topAnchor
        case bottomAnchor
        case leftAnchor
        case height
        case width
        
        var value: CGFloat {
            switch self {
            case .topAnchor:
                return 2
            case .bottomAnchor:
                return -2
            case .leftAnchor:
                return 12
            case .height:
                return 20
            case .width:
                return 20
            }
        }
    }
        
    enum LabelViewConstraints {
        case topAnchor
        case bottomAnchor
        case leftAnchor
        case rightAnchor
        
        var value: CGFloat {
            switch self {
            case .topAnchor:
                return 2
            case .bottomAnchor:
                return -2
            case .leftAnchor:
                return 8
            case .rightAnchor:
                return -12
            }
        }
    }
        
    private func setupUI() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // mainView constraints
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MainViewConstraints.topAnchor.value),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: MainViewConstraints.bottomAnchor.value),
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: MainViewConstraints.leftAnchor.value),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: MainViewConstraints.rightAnchor.value)
        ])
        
        // checkBoxView constraints
        contentView.addSubview(checkBoxView)
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBoxView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: CheckboxConstraints.leftAnchor.value),
            checkBoxView.heightAnchor.constraint(equalToConstant: CheckboxConstraints.height.value),
            checkBoxView.widthAnchor.constraint(equalToConstant: CheckboxConstraints.width.value),
            checkBoxView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: LabelViewConstraints.topAnchor.value),
            labelView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: LabelViewConstraints.bottomAnchor.value),
            labelView.leftAnchor.constraint(equalTo: checkBoxView.rightAnchor, constant: LabelViewConstraints.leftAnchor.value),
            labelView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: LabelViewConstraints.rightAnchor.value),
            
        ])
        
        
    }
    
    private func updateUI() {
        guard let viewModel else { return }
        
        if let label = viewModel.label {
            labelView.text = label
        }
        isChecked = viewModel.isChecked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
        
}

