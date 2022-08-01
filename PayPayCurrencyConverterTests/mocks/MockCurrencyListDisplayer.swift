//
//  MockCurrencyListDisplayer.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter

class MockCurrencyListDisplayer : PPCCurrencyListViewProtocol{
    var currencySelectionCompletionBlock: (((PPCAvailableCurrencyProtocol)) -> Void)?
    
    var isDisplayCurrencyListCalled  = false
    var receivedCurrencyList : [PPCAvailableCurrencyProtocol]!
    
    func showCurrencyPicker(_ availableCurencies: [PPCAvailableCurrencyProtocol]) {
        isDisplayCurrencyListCalled = true
        receivedCurrencyList = availableCurencies
    }
    
    func selectCurrency(_ currency: PPCAvailableCurrency){
        currencySelectionCompletionBlock?(currency)
    }
}
