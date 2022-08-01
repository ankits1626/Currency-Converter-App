//
//  MockDataProvider.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 31/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter

class MockDataProvider{
    
    static func getDummyCurrency() -> PPCAvailableCurrencyProtocol{
        return PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")
    }
    
    
    static var dummyConversionResponseFromServer : String{
        return """
        {
        \"timestamp\": 1659214801,
        \"base\": \"USD\",
        \"rates\": {
          \"AED\": 3.6731,
          \"AFN\": 90,
          \"ALL\": 114.375
            }
        }
        """
    }
    
}
