//
//  PPCErrorDisplayer.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import UIKit

/**
 error displayer displays any kind of error oberved in app
 */
class PPCErrorDisplayer : PPCErrorDisplayerProtocol{
    
    func displayError(_ error: String) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alertVC = UIAlertController(title: "", message: error, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Commons:OK".localized, style: .default)
            alertVC.addAction(okAction)
            topController.present(alertVC, animated: true, completion: nil)
            // topController should now be your topmost view controller
        }
    }
}
