//
//  FilterOptionsView.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 28/11/24.
//

import UIKit

class FilterOptionsView: UIView {
    let viewModel: FilterOptionViewModel

    private let containerStackView = UIStackView()
    private let divider = UIView()
    private var butttons: [UIButton] = []
    private var lastHorizontalStackView: UIStackView?
    private var widthOfHorizontalStackedButtons = 0.0
    private let checkedImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    private let uncheckedImage = UIImage(systemName: "circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    
    init(viewModel: FilterOptionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(containerStackView)
        addSubview(divider)
        divider.backgroundColor = .yellow
        divider.translatesAutoresizingMaskIntoConstraints = false
        configureContainerStackView()
        createButtons()
    }

    private func configureButton(with option: FilterOption) -> UIButton {
        let buttonItem = UIButton(configuration: .plain())
        buttonItem.configuration?.background.backgroundColor = .systemGray5
        buttonItem.configuration?.baseForegroundColor = .black
        buttonItem.configuration?.buttonSize = .small
        buttonItem.configuration?.imagePadding = 4
        buttonItem.layer.cornerRadius = 12
        buttonItem.layer.borderWidth = 1
        buttonItem.layer.borderColor = UIColor.systemGray2.cgColor
        buttonItem.translatesAutoresizingMaskIntoConstraints = false
        buttonItem.configuration?.title = option.title
        
        buttonItem.isSelected = viewModel.isFilterSelected(option)
        if buttonItem.isSelected {
            buttonItem.setImage(checkedImage, for: .normal)
        } else {
            buttonItem.setImage(uncheckedImage, for: .normal)
        }
        buttonItem.sizeToFit()

        buttonItem.addAction(
                UIAction { [weak self] _ in
                    self?.viewModel.actionFor(option)
                   
                }, for: .touchUpInside)
        buttonItem.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        butttons.append(buttonItem)
        return buttonItem
    }
    
    @objc func buttonTap(sender: UIButton) {
        sender.isSelected =  !sender.isSelected
        if sender.isSelected {
            sender.setImage(checkedImage, for: .normal)
        } else {
            sender.setImage(uncheckedImage, for: .normal)
        }
       
    }

    private func configureHorizontalStackViewAndAddToContainer() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4
        lastHorizontalStackView = stackView
        widthOfHorizontalStackedButtons = 0.0
        containerStackView.addArrangedSubview(stackView)
    }
    
    private func addButtonToStack(button: UIButton) {
        lastHorizontalStackView?.addArrangedSubview(button)
        widthOfHorizontalStackedButtons = widthOfHorizontalStackedButtons + button.bounds.size.width + 20
    }
    
    private func configureContainerStackView() {
        containerStackView.axis = .vertical
        containerStackView.spacing = 8
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.alignment = .leading
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func createButtons() {
        for button in viewModel.filterOptions {
            if widthOfHorizontalStackedButtons == 0 {
                configureHorizontalStackViewAndAddToContainer()
                let button = configureButton(with: button)
                addButtonToStack(button: button)
            } else {
                let button = configureButton(with: button)
                if widthOfHorizontalStackedButtons + button.bounds.size.width + 20 > UIScreen.main.bounds.size.width {
                    configureHorizontalStackViewAndAddToContainer()
                    addButtonToStack(button: button)
                } else {
                    addButtonToStack(button: button)
                }
                
            }
        }
    }
}

#if DEBUG
extension FilterOptionsView {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

    struct TestHooks {
        var target: FilterOptionsView
        var butttons: [UIButton] { target.butttons }
    }
}
#endif
