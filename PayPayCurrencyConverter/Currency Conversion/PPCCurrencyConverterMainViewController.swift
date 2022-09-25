//
//  PPCCurrencyConverterMainViewController.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import UIKit

/**
 This is the main view controller of currency converter app. Following use cases are satisfied
 - text widget to enter amount
 - currency selector widget
 - child container to display converted amount in available currency denominations
 */
class PPCCurrencyConverterMainViewController: UIViewController {
    
    //public ivars
    var amountEntered : Double!
    var baseCurrency : PPCAvailableCurrencyProtocol!
    var errorDisplayer: PPCErrorDisplayerProtocol!
    var dataManager: PPCDataProviderProtocol!
    var conversionResultDisplayer : PCCConversionResultDisplayerProtocol!
    
    //Private ivars
    
    
    //Private IBoutlets
    @IBOutlet private weak var amountTfld : UITextField?
    @IBOutlet private weak var currencySelectorWidgetContainer : UIView?
    @IBOutlet private weak var conversionDisplayerContainer : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnVieWDidLoad()
    }
    
    func askDataManagerToConversion(){
        amountTfld?.resignFirstResponder()
        if let unwrappedAmount = amountEntered,
           unwrappedAmount > 0,
           let baseCurrency = baseCurrency{
            dataManager.getConversion(amount: unwrappedAmount, baseCurrency: baseCurrency) { [weak self] result in
                DispatchQueue.main.async {[weak self] in
                    self?.handleConversionResult(result)
                }
            }
        }
    }
}

extension PPCCurrencyConverterMainViewController{
    
    private func setupOnVieWDidLoad(){
        prepareDataManager()
        prepareErrorDisplayer()
        addCurrencySelectionWidget()
        configureTAmountTextField()
        
    }
    
    private func prepareDataManager(){
        if dataManager == nil{
            dataManager = PPCDataManager()
        }
    }
    
    private func prepareErrorDisplayer(){
        if errorDisplayer == nil{
            errorDisplayer = PPCErrorDisplayer()
        }
    }
    
    private func addCurrencySelectionWidget(){
        if let unwrappedCurrencySelectorContainer = currencySelectorWidgetContainer{
            let currencyConversionWidget = PPCCurrencySelectorWidget(
                PPCCurrencySelectorWidgetInitModel(
                    dataManager: dataManager,
                    errorDisplayer: errorDisplayer
                )
            )
            currencyConversionWidget.delegate = self
            currencyConversionWidget.addCurrencySelector(unwrappedCurrencySelectorContainer, parent: self)
        }
    }
    
    private func configureTAmountTextField(){
        amountTfld?.addDoneButtonToKeyboard(#selector(doneButtonPressedForAmountField))
    }
    
    /**
     handle the response it receives from data manager when asked for conversions
     */
     func handleConversionResult(_ result : PPCConversionResultProtocol){
        if let conversions = result.conversions,
           !conversions.isEmpty{
            if conversionResultDisplayer == nil{
                addResultDisplayer()
            }
            conversionResultDisplayer.showConversionResults(conversions)
        }else{
            if let error = result.error{
                errorDisplayer.displayError(error)
            }else{
                errorDisplayer.displayError("Commons:EmptyConversions".localized)
            }
        }
    }
    
    private func addResultDisplayer(){
        let resultDisplayer = PCCConversionResultDisplayerViewController(
            nibName: "PCCConversionResultDisplayerViewController",
            bundle: Bundle(for: PCCConversionResultDisplayerViewController.self)
        )
        addChild(resultDisplayer)
        resultDisplayer.view.frame = conversionDisplayerContainer!.bounds
        conversionDisplayerContainer!.addSubview(resultDisplayer.view)
        resultDisplayer.didMove(toParent: self)
        conversionResultDisplayer = resultDisplayer
    }
    
}

extension PPCCurrencyConverterMainViewController{
    
    @objc private func doneButtonPressedForAmountField(){
        amountTfld?.resignFirstResponder()
        if
            let amountTxt = amountTfld?.text,
            let amount = Double(amountTxt){
            self.amountEntered = amount
            askDataManagerToConversion()
        }
    }
    
}

extension PPCCurrencyConverterMainViewController : PPCCurrencySelectorWidgetDelegate{
    func finishedSelectingCurrency(_ selectedCurrency: PPCAvailableCurrencyProtocol) {
        baseCurrency = selectedCurrency
        askDataManagerToConversion()
    }
}


