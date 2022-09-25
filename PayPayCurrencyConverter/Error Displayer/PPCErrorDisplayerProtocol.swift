//
//  PPCErrorDisplayerProtocol.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import Foundation

/**
 Interface for error dissplayer
 */

protocol PPCErrorDisplayerProtocol : AnyObject{
    func displayError(_ error: String)
}

/**
 Error repositorry used in the app
 */
public enum PPCCustomError : Error{
    case noRecordFound
    case expiredConversionRates
    case noConversionFound
    case invalidEndpoint
    case inValidResponse
}
