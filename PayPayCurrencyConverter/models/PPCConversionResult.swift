//
//  PPCConversionResult.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 01/08/22.
//

import Foundation

/**
 Interface for a conversion result
 */
public protocol PPCConversionResultProtocol{
    var error : String? {get}
    var conversions : [PPCCurrencyConversionProtocol]? {get}
}

/** container for conversion result*/
struct PPCConversionResult : PPCConversionResultProtocol{
    /** error obserbed during a conversion process*/
    var error : String?
    /** array of conversions*/
    var conversions : [PPCCurrencyConversionProtocol]?
}
