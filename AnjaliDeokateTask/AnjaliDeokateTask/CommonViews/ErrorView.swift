//
//  ErrorView.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 01/12/24.
//

import Foundation

import UIKit

enum ErrorType {
    case apiError
    case emptySearchResult
    case emptyFilterResult
    
    var image: UIImage {
        switch self {
        case .apiError:
            return .apiError
        case .emptySearchResult:
            return .emptySearchResult
        case .emptyFilterResult:
            return .emptyFilterResult
        }
    }
    
    var title: String {
        switch self {
        case .apiError:
            "Whoops"
        case .emptySearchResult:
            "No results found"
        case .emptyFilterResult:
            "No match for filter"
        }
    }
    
    var message: String {
        switch self {
        case .apiError:
            "Something went wrong. Please retry again later."
        case .emptySearchResult:
            "Try searching another keyword."
        case .emptyFilterResult:
            "Try another filter option or new search keyword"
        }
    }
    
}

protocol ErrorViewDelegate: AnyObject {
    func retryApi()
}

class ErrorView: UIView {
    private var errorType: ErrorType
    weak var delegate: ErrorViewDelegate?
    
    init(errorType: ErrorType) {
        self.errorType = errorType
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.background.backgroundColor = .yellow
        button.configuration?.baseForegroundColor = .black
        button.configuration?.buttonSize = .large
        button.configuration?.titlePadding = 10
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.title = "RETRY"
        button.addAction(
                UIAction { [weak self] _ in
                    self?.delegate?.retryApi()
                   
                }, for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints  = false
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    private func setupView() {
        backgroundColor = .white
        imageView.image = errorType.image
        titleLabel.text = errorType.title
        subtitleLabel.text = errorType.message

        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        if errorType == .apiError {
            stackView.addArrangedSubview(retryButton)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        if errorType == .apiError {
            stackView.addArrangedSubview(retryButton)
        }
    }
}

#if DEBUG
extension ErrorView {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    struct TestHooks {
        var target: ErrorView
        var errorType: ErrorType { target.errorType }
        var imageView: UIImageView { target.imageView }
        var titleLabel: UILabel { target.titleLabel }
        var subtitleLabel: UILabel { target.subtitleLabel }
    }
}
#endif

