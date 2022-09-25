//
//  PPCDataManager.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import Foundation

/**
 Defines the interface of a data manager
 */
protocol PPCDataProviderProtocol : AnyObject{
    func provideAvailableCurrencies(_ completion : @escaping (_ result : [PPCAvailableCurrencyProtocol]?, _ error: Error?) -> Void)
    func getConversion(amount: Double, baseCurrency: PPCAvailableCurrencyProtocol, completion: @escaping (_ result: PPCConversionResultProtocol) -> Void)
}


/**
 Provides and manages data for app
 */
class PPCDataManager : PPCDataProviderProtocol{
    //public ivars
    var cachedDataManager: PPCCachedDataManagerProtocol!
    var networkDataProvider: PPCDataProviderProtocol!
    
    init(){
        setup()
    }
    
    /**
     method which provide conversions
     following logic is followed
     it check if it receives not expired data from cached data manager it passes it as it
     if it receives error from cached data manager it asks network manager to fetch rates
     it then prepare a conversions list but multiplying amount with conversion rates and reonds as call back
     If network manager returns error then it uses the expired results only
     */
    func getConversion(amount: Double, baseCurrency: PPCAvailableCurrencyProtocol, completion: @escaping(PPCConversionResultProtocol) -> Void) {
        cachedDataManager.getConversion(
            amount: amount,
            baseCurrency: baseCurrency) {[weak self] cachedLocalResult in
                if cachedLocalResult.error != nil{
                    self?.networkDataProvider.getConversion(amount: amount, baseCurrency: baseCurrency) {[weak self] networkFetchResult in
                        if cachedLocalResult.error != nil && networkFetchResult.error != nil{
                            completion(cachedLocalResult)
                        }else if let conversionRates = networkFetchResult.conversions{
                            self?.cachedDataManager.saveConversionRates(conversionRates, baseCurrencyCode: baseCurrency.presentationCurrencyCode)
                            self?.convertFetchedConversionResultForAmount(
                                amount,
                                baseCurrencyCode: baseCurrency.presentationCurrencyCode,
                                fetchedResult: networkFetchResult,
                                completion: { convertedResult in
                                    completion(convertedResult)
                                })
                        } else if (networkFetchResult.error != nil),
                                  let _ = cachedLocalResult.conversions{
                            debugPrint("########## using expired cached conversions")
                            self?.convertFetchedConversionResultForAmount(
                                amount,
                                baseCurrencyCode: baseCurrency.presentationCurrencyCode,
                                fetchedResult: cachedLocalResult,
                                completion: { convertedResult in
                                    completion(convertedResult)
                                })
            
                        }
                    }
                }else{
                    if cachedLocalResult.conversions != nil{
                        self?.convertFetchedConversionResultForAmount(
                            amount,
                            baseCurrencyCode: baseCurrency.presentationCurrencyCode,
                            fetchedResult: cachedLocalResult,
                            completion: { convertedResult in
                                completion(convertedResult)
                            })
                    }
                }
            }
    }
    
    /**
     provides a list of available currencies for conversions
     again it check if cached data is there if not then fetches from network
     */
    func provideAvailableCurrencies(_ completion : @escaping (_ result : [PPCAvailableCurrencyProtocol]?, _ error: Error?) -> Void){
        cachedDataManager.provideAvailableCurrencies {[weak self] result, error in
            if error == nil,
               let unwrappedresult = result,
               !unwrappedresult.isEmpty{
                completion(unwrappedresult, nil)
            }else{
                self?.networkDataProvider.provideAvailableCurrencies { resultFromNetwork, error in
                    if let unwrappedError = error{
                        completion(nil, unwrappedError)
                    }else{
                        if let unwrappedResult = resultFromNetwork,
                           !unwrappedResult.isEmpty{
                            
                            self?.cachedDataManager.saveAvailabeCurrencies(unwrappedResult)
                            completion(unwrappedResult, nil)
                        }else{
                            completion(nil, PPCCustomError.noRecordFound)
                        }
                    }
                }
            }
        }
    }
}

extension PPCDataManager{
   
    private func convertFetchedConversionResultForAmount(_ amount: Double, baseCurrencyCode: String, fetchedResult:PPCConversionResultProtocol, completion: (PPCConversionResultProtocol) -> Void){
        if let conversions = fetchedResult.conversions,
           !conversions.isEmpty{
            var conversionsRelativeToAmount = [PPCCurrencyConversion]()
            for aConversion in conversions{
                conversionsRelativeToAmount.append(
                    PPCCurrencyConversion(
                        currency: aConversion.currency,
                        conversionAmount: aConversion.conversionAmount * amount
                    )
                )
            }
            completion(PPCConversionResult( error: nil, conversions: conversionsRelativeToAmount))
            
        }else{
            completion(fetchedResult)
        }
        
    }
    
}

extension PPCDataManager{
    
    private func setup(){
        setupCachedDataProvider()
        setupNetworkDataProvider()
    }
    
    private func setupCachedDataProvider(){
        if cachedDataManager == nil{
            cachedDataManager = PPCCachedDataManager()
        }
    }
    
    private func setupNetworkDataProvider(){
        if networkDataProvider == nil{
            networkDataProvider = PPCNetworkDataProvider()
        }
    }
}
