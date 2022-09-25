//
//  PPCCachedDataManager.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 31/07/22.
//

import Foundation


protocol PPCCachedDataManagerProtocol : PPCDataProviderProtocol{
    func saveAvailabeCurrencies(_ availableCurrencies: [PPCAvailableCurrencyProtocol] )
    func saveConversionRates (_ conversion : [PPCCurrencyConversionProtocol], baseCurrencyCode: String)
}

/**
 This class reads and process cached data.
 Basically it saves data in memory
 Check if the data is expired or not, if data is expired it will respond with an error to the callers
 It also conerts the conversion rates to new base currency
 */
class PPCCachedDataManager : PPCCachedDataManagerProtocol{
   
    private var conversionRates : [PPCCurrencyConversionProtocol]?
    private var conversionRateExpireTimeStamp : TimeInterval!
    private var conversionRateForCurrency : String!
    
    private var savedAvailableCurrencies : [PPCAvailableCurrencyProtocol]?
    
    func saveConversionRates (_ conversion : [PPCCurrencyConversionProtocol], baseCurrencyCode: String){
        self.conversionRates = conversion
        self.conversionRateExpireTimeStamp = Date.now.timeIntervalSince1970 + (30 * 60)
        self.conversionRateForCurrency = baseCurrencyCode
    }
    
    func saveAvailabeCurrencies(_ availableCurrencies: [PPCAvailableCurrencyProtocol]) {
        self.savedAvailableCurrencies = availableCurrencies
    }
    
    func provideAvailableCurrencies(_ completion: ([PPCAvailableCurrencyProtocol]?, Error?) -> Void) {
        if let currencies = savedAvailableCurrencies{
            debugPrint("<<<<<<<< using cached available currencies")
            completion(currencies, nil)
        }else{
            debugPrint("******** calling network for available currencies")
            completion(nil, PPCCustomError.noRecordFound)
        }
        
    }
    
    /**
     provide conversions
     check if data is expired or not right now data expiry is 30 mins
     */
    func getConversion(amount: Double, baseCurrency: PPCAvailableCurrencyProtocol, completion: (PPCConversionResultProtocol) -> Void) {
        if let unwrappedConversionRated = conversionRates{
            let newConversionRates = convertConversionRatesForBaseCurrencyIfRequired(
                baseCurrency.presentationCurrencyCode,
                conversionRates: unwrappedConversionRated
            )
            if let expiryTime = conversionRateExpireTimeStamp,
               (Date.now.timeIntervalSince1970 < expiryTime){
                print("<<<<<<<< using cached conversions")
                completion(
                    PPCConversionResult(
                        error: nil,
                        conversions: newConversionRates
                    )
                )
            }else{
                completion(
                    PPCConversionResult(
                        error: PPCCustomError.expiredConversionRates.localizedDescription,
                        conversions: newConversionRates
                    )
                )
            }
                
        }else{
            debugPrint("******** calling network for conversions")
            completion(PPCConversionResult( error: PPCCustomError.noRecordFound.localizedDescription, conversions: nil))
        }
        
    }
    
    private func convertConversionRatesForBaseCurrencyIfRequired(_ newBaseCurrency: String, conversionRates : [PPCCurrencyConversionProtocol]) -> [PPCCurrencyConversionProtocol]{
        
        if newBaseCurrency != conversionRateForCurrency!{
            if let rateForNewBaseCurrency = conversionRates.filter({ x in
                return x.currency.presentationCurrencyCode == newBaseCurrency
            }).first{
                var newRates = [PPCCurrencyConversionProtocol]()
                for rate in conversionRates{
                    newRates.append(
                        PPCCurrencyConversion(
                            currency: rate.currency,
                            conversionAmount: rate.conversionAmount/rateForNewBaseCurrency.conversionAmount
                        )
                    )
                }
                return newRates
            }
        }
        return conversionRates
    }
}
