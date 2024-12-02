//
//  CryptoListViewModel.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 27/11/24.
//

import UIKit
import Combine

protocol FilterResultDelegate: AnyObject {
    func filterResult(shouldShowFilteredResult: Bool, filteredResults: [Crypto])
}

protocol FilterOptionsDelegate: AnyObject {
    func updateActiveFilters(with options: [FilterOption])
}

class CryptoListViewModel: FilterOptionsDelegate {
    @Published var displayedCryptoList: [Crypto] = []
    private var cryptoList: [Crypto] = []
    
    private var searchQuery: String = ""
    private var searchResult: [Crypto] = []
    
    private var filteredResult: [Crypto] = []
    var activeFilters: [FilterOption] = []
    
    private let service: CryptoService
    weak var viewDelegate: CryptoListViewDelegate?
    private var bindings = Set<AnyCancellable>()

    init(service: CryptoService = APIManager.shared) {
        self.service = service
        setUpBindings()
    }
    
    private func setUpBindings() {
        $displayedCryptoList
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.viewDelegate?.reloadTableView()
                    self?.viewDelegate?.hideLoader()
                }
            })
            .store(in: &bindings)
    }
    
    
    func getCryptoList() {
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure:
                self?.viewDelegate?.hideError()
                self?.viewDelegate?.showError(errorType: .apiError)
            }
        }

        let cryptoListHandler: ([Crypto]) -> Void = { [weak self] cryptos in
            self?.cryptoList = cryptos
            self?.displayedCryptoList = cryptos
            self?.viewDelegate?.showFilterOptionsViewView()
        }
        service.getCryptoList()
            .sink(receiveCompletion: completionHandler, receiveValue: cryptoListHandler)
            .store(in: &bindings)
    }
}


//MARK: Search + Filter
extension CryptoListViewModel {
    private var searchAndFilterList: [Crypto] {
        if filteredResult.isEmpty {
            if searchResult.isEmpty {
                return []//cryptoList //AD []
            } else {
                return searchResult
            }
        } else {
            if searchQuery.isEmpty {
                return filteredResult
            } else {
                return filteredResult.filter({ (coin: Crypto) -> Bool in
                    let nameMatch = coin.name.range(of: searchQuery, options: NSString.CompareOptions.caseInsensitive)
                    let symbolMatch = coin.symbol.range(of: searchQuery, options: NSString.CompareOptions.caseInsensitive)
                    return nameMatch != nil || symbolMatch != nil
                })
                
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchQuery =  searchText
        if searchText.isEmpty {
            searchResult = cryptoList
        } else {
            searchResult = cryptoList.filter({ (coin: Crypto) -> Bool in
                let nameMatch = coin.name.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let symbolMatch = coin.symbol.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return nameMatch != nil || symbolMatch != nil
            })
        }
        
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if searchAndFilterList.isEmpty {
                self.viewDelegate?.showError(errorType: .emptySearchResult)
            } else {
                self.displayedCryptoList = self.searchAndFilterList
                self.viewDelegate?.hideError()
            }
        }
    }

}

//MARK: Filter + Search
extension CryptoListViewModel {
    private var filterAndSearch: [Crypto] {
        if filteredResult.isEmpty {
            if searchResult.isEmpty {
                return cryptoList
            } else {
                return searchResult
            }
        } else {
            if searchQuery.isEmpty {
                return filteredResult
            } else {
                return filteredResult.filter({ (coin: Crypto) -> Bool in
                    let nameMatch = coin.name.range(of: searchQuery, options: NSString.CompareOptions.caseInsensitive)
                    let symbolMatch = coin.symbol.range(of: searchQuery, options: NSString.CompareOptions.caseInsensitive)
                    return nameMatch != nil || symbolMatch != nil
                })
            }
        }
    }
    
    func updateActiveFilters(with options: [FilterOption]) {
        activeFilters = options
    }
    
    func filterResult(shouldShowFilteredResult: Bool, filteredResults: [Crypto]) {
        self.filteredResult = filteredResults
        if shouldShowFilteredResult {
            if filteredResults.isEmpty {
                self.viewDelegate?.showError(errorType: .emptyFilterResult)
            } else {
                
                self.displayedCryptoList = filterAndSearch
                
                if filterAndSearch.isEmpty {
                    self.viewDelegate?.showError(errorType: .emptyFilterResult)
                } else {
                    self.viewDelegate?.hideError()
                }
                
            }
        } else {
            self.displayedCryptoList = filterAndSearch
            if filterAndSearch.isEmpty {
                self.viewDelegate?.showError(errorType: .emptyFilterResult)
            } else {
                self.viewDelegate?.hideError()
            }
        }
    }
}


#if DEBUG
extension CryptoListViewModel {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

    struct TestHooks {
        var target: CryptoListViewModel
        var cryptoList: [Crypto] { target.cryptoList }
        var searchQuery: String { target.searchQuery }
        var filteredResult: [Crypto] { target.filteredResult }
        var activeFilters: [FilterOption] { target.activeFilters }
        
        func updateDisplayedList(with list: [Crypto]) {
            target.displayedCryptoList = list
        }
        
        func updateCryptoList(with list: [Crypto]) {
            target.cryptoList = list
        }
    
        func updateFilterResult(activeFilters: [FilterOption], filteredList: [Crypto]) {
            target.activeFilters = activeFilters
            target.filteredResult = filteredList
        }
    }
}
#endif

