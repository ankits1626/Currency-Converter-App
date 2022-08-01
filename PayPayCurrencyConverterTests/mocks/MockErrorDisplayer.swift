//
//  MockErrorDisplayer.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter


class MockErrorDisplayer : PPCErrorDisplayerProtocol{
    
    var isDisplayErrorCalled  = false
    
    func displayError(_ error: String) {
        isDisplayErrorCalled = true
    }
}
