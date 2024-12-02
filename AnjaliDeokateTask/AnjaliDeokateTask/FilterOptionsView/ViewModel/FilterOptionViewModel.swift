//
//  FilterOptionViewModel.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 28/11/24.
//

import Foundation
import Combine

class FilterOptionViewModel {
    var filterOptions: [FilterOption] = [.activeCoins,
                                         .inactiveCoins,
                                         .onlyTokens,
                                         .onlyCoins,
                                         .newCoins]
    var lastDisplayedList: [Crypto]
    @Published private var activeFilters: [FilterOption]
    private var filteredResults: [Crypto] = []

    weak var delegate: FilterResultDelegate?
    weak var filterOptionsDelegate: FilterOptionsDelegate?
    
    private var bindings = Set<AnyCancellable>()
    
    private func setUpBindings() {
        $activeFilters
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    filterOptionsDelegate?.updateActiveFilters(with: activeFilters)
                }
            })
            .store(in: &bindings)
    }
    
    func isFilterSelected(_ option: FilterOption) -> Bool {
        activeFilters.contains(option) ? true : false
    }

    init(activeFilters: [FilterOption], lastDisplayedList: [Crypto]) {
        self.activeFilters = activeFilters
        self.lastDisplayedList = lastDisplayedList
        setUpBindings()
    }
        
    func actionFor(_ option: FilterOption) {
        switch option {
        case .activeCoins:
            if activeFilters.contains(.activeCoins) {
                activeFilters.removeAll(where: { $0 == .activeCoins } )
            } else {
                activeFilters.append(.activeCoins)
            }
            
        case .inactiveCoins:
            
            if activeFilters.contains(.inactiveCoins) {
                activeFilters.removeAll(where: { $0 == .inactiveCoins } )
            } else {
                activeFilters.append(.inactiveCoins)
            }
        case .onlyTokens:
            
            if activeFilters.contains(.onlyTokens) {
                activeFilters.removeAll(where: { $0 == .onlyTokens } )
            } else {
                activeFilters.append(.onlyTokens)
            }
            
        case .onlyCoins:
            
            if activeFilters.contains(.onlyCoins) {
                activeFilters.removeAll(where: { $0 == .onlyCoins } )
            } else {
                activeFilters.append(.onlyCoins)
            }
        case .newCoins:
            
            if activeFilters.contains(.newCoins) {
                activeFilters.removeAll(where: { $0 == .newCoins } )
            } else {
                activeFilters.append(.newCoins)
            }
        }
        
        filteredResults = lastDisplayedList.filter { crypto in
            var isFiltered = false
            
            for filter in activeFilters {
                if ((filter == .onlyTokens && crypto.isToken) ||
                    (filter == .onlyCoins && crypto.isCoin) ||
                    (filter == .newCoins && crypto.isNewCoin) ||
                    (filter == .activeCoins && crypto.isActiveCoin) ||
                    (filter == .inactiveCoins && crypto.isInactiveCoin)) {
                    isFiltered = true
                    break
                }
            }
            return isFiltered
        }
        let shouldShowFilteredResult = activeFilters.count != 0 && activeFilters.count != 5
        
        delegate?.filterResult(shouldShowFilteredResult: shouldShowFilteredResult,
                               filteredResults: shouldShowFilteredResult ? filteredResults : [])
    }
}

#if DEBUG
extension FilterOptionViewModel {
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

    struct TestHooks {
        var target: FilterOptionViewModel
        var filteredResults: [Crypto] { target.filteredResults }
        var activeFilters: [FilterOption] { target.activeFilters }
        
        func upaateActiveFilter(with activeFilters: [FilterOption]) {
            target.activeFilters = activeFilters
            
        }
    }
}
#endif
