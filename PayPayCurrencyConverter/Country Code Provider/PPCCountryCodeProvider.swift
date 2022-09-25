//
//  PPCCountryCodeProvider.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 01/08/22.
//

import Foundation

class PPCCountryCodeProvider{
    var countriesMap =  [[String : String]]()
    
    init(){
        if let path = Bundle.main.path(forResource: "countryCode", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String : String]] {
                    countriesMap = jsonResult      // do stuff
                  }
              } catch {
              }
        }
    }
    
    func getCountryCode(_ currencyCode : String) -> String?{
        for country in countriesMap{
            if let cCode = country["Currency Code"],
               currencyCode == cCode{
                return country["Country Code"]
            }
        }
        return nil
    }
    
    func getCurrencyName(_ currencyCode : String) -> String?{
        for country in countriesMap{
            if let cCode = country["Currency Code"],
               currencyCode == cCode{
                return country["CurrencyName"]
            }
        }
        return nil
    }
}
