//
//  LoaderViewController.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 27/11/24.
//

import UIKit

class LoaderView: UIView {
    private var spinner = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        setupView()
        spinner.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .black
        spinner.color = .yellow
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

#if DEBUG
extension LoaderView {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

    struct TestHooks {
        var target: LoaderView
        var spinner: UIActivityIndicatorView { target.spinner }
    }
}
#endif

