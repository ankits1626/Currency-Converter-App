//
//  MockConversionResultDisplayer.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 31/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter

/**
 Mock converion diplayer class
 */
class MockConversionResultDisplayer : PCCConversionResultDisplayerProtocol{
    
    var conversions : [PPCCurrencyConversionProtocol]!
    
    func showConversionResults(_ conversions: [PPCCurrencyConversionProtocol]) {
        self.conversions = conversions
    }
}
