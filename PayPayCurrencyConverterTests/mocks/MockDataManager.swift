//
//  MockDataManager.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 30/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter


struct DummyCurrencyConversionResult : PPCConversionResultProtocol{
    var conversions: [PPCCurrencyConversionProtocol]?
    var error: String?
}

struct DummyCurrencyConversion : PPCCurrencyConversionProtocol{
    var presentableCovertedAmount: String{
        return "Dummy"
    }
    
    var currency: PPCAvailableCurrencyProtocol{
        return PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollar")
    }
    
    var conversionAmount: Double = 10.0
    
    
}

/**
 MockDataManager used in unit tests
 */
class MockDataManager : PPCDataProviderProtocol{
    
    var isProvideAvailableCurrenciesCalled  = false
    var shouldReturnError = false
    var shouldReturnEmptyCurrenciesArray = false
    var dummyAvailableCurrencies : [PPCAvailableCurrencyProtocol]!
    
    func provideAvailableCurrencies(_ completion : (_ result : [PPCAvailableCurrencyProtocol]?, _ error: Error?) -> Void) {
        isProvideAvailableCurrenciesCalled = true
        if shouldReturnError{
            completion(nil, PPCCustomError.noRecordFound)
        }else if shouldReturnEmptyCurrenciesArray{
            completion([PPCAvailableCurrencyProtocol](), nil)
        }else{
            if let unwrappedDummyCurrencies =  dummyAvailableCurrencies{
                completion(unwrappedDummyCurrencies, nil)
            }else{
                completion(
                    [
                        PPCAvailableCurrency(currencyCode: "JPY", currencyName: "Japanese yen"),
                        PPCAvailableCurrency(currencyCode: "USD", currencyName: "US Dollars")
                    ],
                    nil
                )
            }
        }
    }
    
    var isCalledForConversion = false
    var shouldReturnErrorAfterConversion = false
    var shouldReturnEmptyAfterConversion = false
    func getConversion(amount: Double, baseCurrency: PPCAvailableCurrencyProtocol, completion: (PPCConversionResultProtocol) -> Void) {
        isCalledForConversion = true
        if shouldReturnErrorAfterConversion{
            completion(DummyCurrencyConversionResult(conversions: nil, error: "Dummy Error"))
        }else if shouldReturnEmptyAfterConversion{
            completion(DummyCurrencyConversionResult(conversions: [PPCCurrencyConversionProtocol](), error: nil))
        }
        else{
            completion(DummyCurrencyConversionResult(conversions: [DummyCurrencyConversion()], error: nil))
        }
    }
}
