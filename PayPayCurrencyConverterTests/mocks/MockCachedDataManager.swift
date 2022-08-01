//
//  MockCachedDataProvider.swift
//  PayPayCurrencyConverterTests
//
//  Created by Ankit on 31/07/22.
//

import Foundation
@testable import PayPayCurrencyConverter

class MockCachedDataManager : PPCCachedDataManagerProtocol{
    
    var conversionRates : [PPCCurrencyConversionProtocol]!
    func saveConversionRates(_ conversion: [PPCCurrencyConversionProtocol], baseCurrencyCode: String) {
        self.conversionRates = conversion
    }
    
    var savedAvailableCurrencies : [PPCAvailableCurrencyProtocol]!
    func saveAvailabeCurrencies(_ availableCurrencies: [PPCAvailableCurrencyProtocol]) {
        self.savedAvailableCurrencies = availableCurrencies
    }
    
    var isProvideAvailableCurrenciesCalled  = false
    var shouldReturnErrorForavailableCurrencies = false
    var shouldReturnEmptyCurrenciesArray = false
    var dummyAvailableCurrencies : [PPCAvailableCurrencyProtocol]!
    
    func provideAvailableCurrencies(_ completion : (_ result : [PPCAvailableCurrencyProtocol]?, _ error: Error?) -> Void) {
        isProvideAvailableCurrenciesCalled = true
        if shouldReturnErrorForavailableCurrencies{
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
