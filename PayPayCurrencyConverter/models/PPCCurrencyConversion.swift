//
//  PPCCurrencyConversion.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 01/08/22.
//

import Foundation

/**
 Interface of a conversion
 */
public protocol PPCCurrencyConversionProtocol{
    var currency : PPCAvailableCurrencyProtocol {get}
    var conversionAmount : Double {get}
    var presentableCovertedAmount : String {get}
}

/**
 container to hold convesions
 */
struct PPCCurrencyConversion : PPCCurrencyConversionProtocol{
    var currency : PPCAvailableCurrencyProtocol
    var conversionAmount : Double
    
    var presentableCovertedAmount : String{
        return "\(String(format: "%.2f", conversionAmount)) \(currency.presentationCurrencyCode)"
    }
}
