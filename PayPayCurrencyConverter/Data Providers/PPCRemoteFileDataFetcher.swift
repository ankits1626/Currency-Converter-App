//
//  PPCRemoteFileDataFetcher.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 31/07/22.
//

import Foundation
/**
 Interfaces for a remote file data fetcher
 */
protocol PPCRemoteFileDataFetcherProtocol{
    var baseUrl : String {get}
    func readRemoteJsonFile(_ endPoint: String, appID: String?, currencyCode: String?, completion: @escaping (_ fileContent: Data?, _ error: Error?) -> Void)
}

/**
 This class fetches data from a remote file
 as of now the json files
 */
class PPCRemoteFileDataFetcher : PPCRemoteFileDataFetcherProtocol{
    var baseUrl: String{
        return "https://openexchangerates.org/api/"
    }
    
    /**
     main method which triggers the actual network calls to fetchh data
     appID: open ecxchange app iD
     currencyCode: base currency code a parameter required by open exchange apis
     */
    func readRemoteJsonFile(_ endPoint: String, appID: String?, currencyCode: String?, completion: @escaping (Data?, Error?) -> Void) {
        var fileUrlStr = baseUrl + endPoint
        if let unwrappedAppId = appID,
           let unwrappedCurrencyCode = currencyCode{
            fileUrlStr = fileUrlStr + "?app_id=\(unwrappedAppId)"
            fileUrlStr = fileUrlStr + "&base=\(unwrappedCurrencyCode)"
        }
        
        if let fileUrl = URL(string: fileUrlStr){
            let task = URLSession.shared.dataTask(with: fileUrl) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode.isOK,
                    let unwrappedData = data{
                        completion(unwrappedData, nil)
                    }else{
                        completion(nil, error)
                    }
                    
                }else{
                    completion(nil, PPCCustomError.inValidResponse)
                }
            }
            task.resume()
            
        }else{
            completion(nil, PPCCustomError.invalidEndpoint)
        }
    }
}
