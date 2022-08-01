//
//  MockCurrencyWidgetDelegate.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter


class MockCurrencyWidgetDelegate : PPCCurrencySelectorWidgetDelegate{
    var selectedCurrency : PPCAvailableCurrencyProtocol!
    
    func finishedSelectingCurrency(_ selectedCurrency: PPCAvailableCurrencyProtocol) {
        self.selectedCurrency = selectedCurrency
    }
}
