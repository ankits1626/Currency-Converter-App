//
//  PPCAvailableCurrency.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import Foundation

/**
 Defines the interface of a Available Currency Model
 */
public protocol PPCAvailableCurrencyProtocol{
    var presentationCurrencyName: String {get}
    var presentationCurrencyCode: String {get}
}


/**
 This class represents a currency 
 */
class PPCAvailableCurrency : PPCAvailableCurrencyProtocol{
    /**name of a currency**/
    var presentationCurrencyName: String
    /** ISCO currency code*/
    var presentationCurrencyCode: String
    
    init(currencyCode: String, currencyName: String) {
        self.presentationCurrencyName = currencyName
        self.presentationCurrencyCode = currencyCode
    }
}
