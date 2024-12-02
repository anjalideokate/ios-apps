//
//  CryptoListViewController.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 27/11/24.
//

import UIKit

protocol CryptoListViewDelegate: AnyObject {
    func reloadTableView()
    func showLoader()
    func hideLoader()
    func showFilterOptionsViewView()
    func showError(errorType: ErrorType)
    func hideError()
}

class CryptoListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: CryptoListViewModel
    private var loaderView: LoaderView?
    private var errorView: ErrorView?
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Name or Symbol"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        return searchController
    }()
    
    init(viewModel: CryptoListViewModel = CryptoListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var filterOptionsView: FilterOptionsView = {
        let filterOptionsView = getFilterOptionsView()
        filterOptionsView.accessibilityIdentifier = "FilterOptionsView"
        filterOptionsView.translatesAutoresizingMaskIntoConstraints = false
        return filterOptionsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
        setupConstraints()
        showLoader()
        viewModel.getCryptoList()
    }
    
    private func setupView() {
        view.backgroundColor = .black
        edgesForExtendedLayout = []
        view.addSubview(tableView)
        view.addSubview(filterOptionsView)
        viewModel.viewDelegate = self
        ()
    }
    
    private func setupNavigationBar() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .black
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.yellow]
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationItem.title = "COIN"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.allowsSelection = false
        searchController.searchResultsUpdater = self
        tableView.register(CryptoCellView.self, forCellReuseIdentifier: CryptoCellView.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 5
        tableView.accessibilityIdentifier = "TableView"
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        filterOptionsViewContraints()
    }

    private func filterOptionsViewContraints() {
        NSLayoutConstraint.activate([
            filterOptionsView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            filterOptionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filterOptionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filterOptionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        filterOptionsView.removeFromSuperview()
        filterOptionsView = getFilterOptionsView()
        view.addSubview(filterOptionsView)
        filterOptionsView.isHidden =  false
        filterOptionsViewContraints()
    }
}

// MARK: Table View
extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedCryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCellView.identifier, for: indexPath) as? CryptoCellView else {
            fatalError("The TableView coult not dequeue a CustomCell in ViewController")
        }
        let crypto = viewModel.displayedCryptoList[(indexPath as NSIndexPath).row]
        cell.configure(viewModel: CryptoCellViewModel(crypto: crypto))
        return cell
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
// MARK: Search
extension CryptoListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.filterContentForSearchText(searchText)
        }
    }
}


// MARK: Filter options view
extension CryptoListViewController: FilterResultDelegate {
    private func getFilterOptionsView() -> FilterOptionsView {
        let viewModel = FilterOptionViewModel(activeFilters: viewModel.activeFilters,
                                        lastDisplayedList: viewModel.displayedCryptoList)
        let filterOptionsView = FilterOptionsView(viewModel: viewModel)
        filterOptionsView.backgroundColor = .black
        viewModel.delegate = self
        viewModel.filterOptionsDelegate = self.viewModel
        filterOptionsView.translatesAutoresizingMaskIntoConstraints = false
        filterOptionsView.isHidden = true
        return filterOptionsView
    }

    func showFilterOptionsViewView() {
        filterOptionsView.viewModel.lastDisplayedList = viewModel.displayedCryptoList
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIView.transition(with: view,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                guard let self else { return }
                filterOptionsView.isHidden = false
            })
        }
    }
    
    func filterResult(shouldShowFilteredResult: Bool, filteredResults: [Crypto]) {
        viewModel.filterResult(shouldShowFilteredResult: shouldShowFilteredResult,
                               filteredResults: filteredResults)
    }
}

// MARK: Error view for api error, empty search result error, empty filter result error
extension CryptoListViewController {
    func hideError() {
        guard let errorView else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIView.transition(with: view,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: { [weak self] in
                guard let self else { return }
                errorView.removeFromSuperview()
                self.errorView = nil
                filterOptionsView.isHidden = false
            })
        }
    }
    
    func showError(errorType: ErrorType) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if errorType == .emptyFilterResult {
                filterOptionsView.isHidden = false
            } else {
                filterOptionsView.isHidden = true
            }
            if errorView != nil {
                return
            }
            errorView = ErrorView(errorType: errorType)
            guard let errorView else { return }
            errorView.frame = view.frame
            errorView.isHidden = true
            errorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(errorView)
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            errorView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            errorView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            if errorType == .emptyFilterResult {
                errorView.bottomAnchor.constraint(equalTo: filterOptionsView.topAnchor).isActive = true
            } else {
                errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            }
            
            errorView.delegate = self

            UIView.transition(with: view,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: {
                errorView.isHidden = false
            })
        }
    }
}

// MARK: Loader view for api response waiting time
extension CryptoListViewController: CryptoListViewDelegate {
    func showLoader() {
        if loaderView != nil {
            return
        }
        loaderView = LoaderView()
        guard let loaderView else { return }
        view.addSubview(loaderView)
        loaderView.frame = view.frame
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loaderView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        loaderView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.bringSubviewToFront(loaderView)
    }

    func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self,
                  let loaderView else { return }
            loaderView.removeFromSuperview()
            self.loaderView = nil
        }
    }
}

// ERROR retry
extension CryptoListViewController: ErrorViewDelegate {
    func retryApi() {
        hideError()
        showLoader()
        viewModel.getCryptoList()
    }
}

#if DEBUG
extension CryptoListViewController {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

    struct TestHooks {
        var target: CryptoListViewController
        var tableView: UITableView { target.tableView }
        var viewModel: CryptoListViewModel { target.viewModel }
        var loaderView: LoaderView? { target.loaderView }
        var errorView: ErrorView? { target.errorView }
        var searchController: UISearchController { target.searchController }
        var filterOptionsView: FilterOptionsView { target.filterOptionsView }
    }
}
#endif
