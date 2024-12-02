//
//  CryptoCellView.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 28/11/24.
//

import UIKit

class CryptoCellView: UITableViewCell {
    
    static let identifier = "CryptoCellView"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageIcon : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let newTagIcon : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CryptoCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        self.imageIcon.image = viewModel.imageIcon
        self.newTagIcon.image = viewModel.newTagIcon
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(imageIcon)
        containerView.addSubview(newTagIcon)        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 8),
            titleLabel.heightAnchor.constraint(equalTo: subtitleLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant:8),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant:-8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant:8),
        ])
        
        NSLayoutConstraint.activate([
            imageIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            imageIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            imageIcon.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: 8),
            
            imageIcon.widthAnchor.constraint(equalTo: imageIcon.heightAnchor),
            imageIcon.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 2)
        ])
        
        NSLayoutConstraint.activate([
            newTagIcon.centerXAnchor.constraint(equalTo: imageIcon.centerXAnchor),
            newTagIcon.topAnchor.constraint(equalTo: containerView.topAnchor),
            newTagIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            newTagIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageIcon.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageIcon.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        newTagIcon.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        newTagIcon.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

#if DEBUG
extension CryptoCellView {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
    struct TestHooks {
        var target: CryptoCellView
        var containerView: UIView { target.containerView }
        var titleLabel: UILabel { target.titleLabel }
        var subtitleLabel: UILabel { target.subtitleLabel }
        var imageIcon: UIImageView { target.imageIcon }
        var newTagIcon: UIImageView { target.newTagIcon }
    }
}
#endif

