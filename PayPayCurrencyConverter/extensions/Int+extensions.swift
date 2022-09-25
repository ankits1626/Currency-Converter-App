//
//  Int+extensions.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 31/07/22.
//

import Foundation

extension Int {
    public var isOK : Bool {
        if 200 ... 299 ~= self {
            return true
        }
        return false
    }
    public var isUnauthorized : Bool {
        if 401 == self {
            return true
        }
        return false
    }
}
