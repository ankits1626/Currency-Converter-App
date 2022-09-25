//
//  PPCNetworkDataProvider.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 31/07/22.
//

import Foundation

/**
 This class fetched the data via the network and process them.
 It will interact with the PPApiCallManager and CoreData Coordinator
 Received the data via api call manager, rocess its and pass it to core data coordinator to save it
 */
class PPCNetworkDataProvider : PPCDataProviderProtocol{
    //public ivars
    var remoteFileReader : PPCRemoteFileDataFetcherProtocol!
    
    init(){
        setup()
    }
    
    func provideAvailableCurrencies(_ completion: @escaping ([PPCAvailableCurrencyProtocol]?, Error?) -> Void) {
        remoteFileReader.readRemoteJsonFile("currencies.json", appID: nil, currencyCode: nil) { fileContent, error in
            if let unwrappedError = error{
                completion(nil, unwrappedError)
            }else{
                if let unwrappedData = fileContent{
                    do{
                        if let json = try JSONSerialization.jsonObject(with: unwrappedData) as? [String : String],
                           !json.isEmpty{
                            
                            var availableCurrencies = [PPCAvailableCurrencyProtocol]()
                            availableCurrencies.append(PPCAvailableCurrency(currencyCode: "USD", currencyName: "United States Dollar"))
                            for currency in json{
                                availableCurrencies.append(PPCAvailableCurrency(currencyCode: currency.key, currencyName: currency.value))
                            }
                            completion(availableCurrencies, nil)
                        }else{
                            completion(nil, PPCCustomError.noRecordFound)
                        }

                    }catch let jsonError{
                        completion(nil, jsonError)
                    }
                }else{
                    completion(nil, PPCCustomError.noRecordFound)
                }
            }
        }
    }
    
    func getConversion(amount: Double, baseCurrency: PPCAvailableCurrencyProtocol, completion: @escaping (PPCConversionResultProtocol) -> Void) {
        
        print("<<<<<<< startef getting conversions")
        remoteFileReader.readRemoteJsonFile("latest.json", appID: "c31236028bf14d49ab422e85bbb46b78", currencyCode: baseCurrency.presentationCurrencyCode) { fileContent, error in
            print("<<<<<<< finished getting conversions")
            if let unwrappedData = fileContent{
                do{
                    if let json = try JSONSerialization.jsonObject(with: unwrappedData) as? [String : Any],
                       let rates = json ["rates"] as? [String : Double],
                       !rates.isEmpty{
                        
                        var conversions = [PPCCurrencyConversionProtocol]()
                        for rate in rates{
                            conversions.append(
                                PPCCurrencyConversion(
                                    currency: PPCAvailableCurrency(currencyCode: rate.key, currencyName: "Dummy1"),
                                    conversionAmount: rate.value
                                )
                            )
                        }
                        completion(PPCConversionResult(error: nil, conversions: conversions))
                    }else{
                        completion(PPCConversionResult(error: PPCCustomError.noConversionFound.localizedDescription, conversions: nil))
                    }

                }catch let jsonError{
                    completion(PPCConversionResult(error: jsonError.localizedDescription, conversions: nil))
                }
            }else{
                completion(PPCConversionResult(error: PPCCustomError.noConversionFound.localizedDescription, conversions: nil))
            }
        }
    }
}


extension PPCNetworkDataProvider{
    private func setup(){
//        setupApiManager()
        setupRemoteFileReader()
    }
    
    
    private func setupRemoteFileReader(){
        if remoteFileReader == nil{
            remoteFileReader = PPCRemoteFileDataFetcher()
        }
    }
}
