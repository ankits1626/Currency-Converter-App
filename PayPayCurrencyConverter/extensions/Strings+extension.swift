//
//  Strings+extension.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
