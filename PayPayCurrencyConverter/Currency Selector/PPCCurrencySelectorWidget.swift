//
//  PPCCurrencySelectorWidget.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import UIKit

/**
 Initialization model for a currency selector widget
 - data manager:- to provide data
 - error displayer : to display any error oberseved
 */
struct PPCCurrencySelectorWidgetInitModel{
    weak var dataManager: PPCDataProviderProtocol?
    weak var errorDisplayer: PPCErrorDisplayerProtocol?
}

/**
 Interfaces which deleagte of a currency selector will receives
 */
protocol PPCCurrencySelectorWidgetDelegate : AnyObject{
    func finishedSelectingCurrency(_ selectedCurrency: PPCAvailableCurrencyProtocol)
}

/**
 This ia a widget to select a currency
 This class interacts with central data manager to fetch the available currencies
 */
class PPCCurrencySelectorWidget: UIViewController {
    
    //Public ivars
    weak var availableCurrencyPicker : PPCCurrencyListViewProtocol?
    var selectedCurrency : PPCAvailableCurrencyProtocol?
    weak var delegate : PPCCurrencySelectorWidgetDelegate?
    
    //Private IBOutlets
    @IBOutlet private weak var currencyCodeLbl: UILabel?
    @IBOutlet private weak var currencyNameLbl: UILabel?
    @IBOutlet private weak var currencyFlagIvew: UIImageView?
    @IBOutlet private weak var currencyPickerPlaceHolderContainer: UIView?
    @IBOutlet private weak var currencyPickerPlaceHolderLbl: UILabel?
    @IBOutlet private weak var currencyPickerTapListenerBtn: UIButton?
    
    //Private ivars
    
    private let initModel: PPCCurrencySelectorWidgetInitModel
    private var errorDisplayer: PPCErrorDisplayerProtocol?{
        return initModel.errorDisplayer
    }
    
    
    public init(_ initModel: PPCCurrencySelectorWidgetInitModel) {
        self.initModel = initModel
        super.init(nibName: "PPCCurrencySelectorWidget", bundle: Bundle(for: PPCCurrencySelectorWidget.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnViewDidLoad()
    }
    
}

extension PPCCurrencySelectorWidget{
    private func setupOnViewDidLoad(){
        configureSelectorUI()
        togglePlaceholder()
    }
    
    private func configureSelectorUI(){
        currencyPickerPlaceHolderContainer?.curvedCornerControl()
        currencyPickerPlaceHolderLbl?.text = "CurrencySelector: Placeholder".localized
        
    }
    
    private func togglePlaceholder(){
        currencyPickerPlaceHolderContainer?.isHidden = selectedCurrency != nil
    }
    
    private func updateUIAfterCurrencySelection(){
        togglePlaceholder()
        self.currencyCodeLbl?.text = selectedCurrency?.presentationCurrencyCode
        self.currencyNameLbl?.text = selectedCurrency?.presentationCurrencyName
    }
}

extension PPCCurrencySelectorWidget{
    @IBAction func selectCurrencyTapped(){
        print("select currency tapped")
        initModel.dataManager?.provideAvailableCurrencies({ [weak self] result, error  in
            DispatchQueue.main.async {
                self?.handleAvaileCurrenciesResponse(result, error)
            }
        })
    }
    
    /**
     how the widget hndles the response it get from data manager when it asks to provide available currencies
     */
    public func handleAvaileCurrenciesResponse(_ result : [PPCAvailableCurrencyProtocol]?, _ error: Error?){
        if let unwrappedError = error{
            errorDisplayer?.displayError(unwrappedError.localizedDescription)
        }else{
            if let unwrappedresult  = result,
               !unwrappedresult.isEmpty{
                showCurrencyPicker(unwrappedresult)
            }else{
                errorDisplayer?.displayError("Errors:NoCurrencyAvailable".localized)
            }
        }
    }
    
    private func showCurrencyPicker(_ availableCurrencies : [PPCAvailableCurrencyProtocol]){
        if availableCurrencyPicker == nil{
            let _availableCurrencyPicker = PPCCurrencyListViewController(
                nibName: "PPCCurrencyListViewController", bundle: Bundle(for: PPCCurrencyListViewController.self)
            )
            _availableCurrencyPicker.showPopover(sourceView: currencyPickerTapListenerBtn!)
            self.availableCurrencyPicker = _availableCurrencyPicker
        }
        availableCurrencyPicker?.currencySelectionCompletionBlock = {[weak self]  selectedCurrency in
            self?.handleSelectedCurrencyFromCurrencyList(selectedCurrency)
        }
        availableCurrencyPicker?.showCurrencyPicker(availableCurrencies)
    }
    
    /**
     handle currency selection from currency picker
     */
    public func handleSelectedCurrencyFromCurrencyList(_ selectedCurrency: PPCAvailableCurrencyProtocol){
        self.selectedCurrency = selectedCurrency
        updateUIAfterCurrencySelection()
        delegate?.finishedSelectingCurrency(selectedCurrency)
    }
}

extension PPCCurrencySelectorWidget{
    func addCurrencySelector(_ currencySelectorWidgetContainer: UIView, parent: UIViewController){
        /**
         this method allows to add a currency selection widget to a container
         since this widget is a view controller, thus parent view controller is required to follow protocol to add a child view controller to parent
         */
        parent.addChild(self)
        self.view.frame = currencySelectorWidgetContainer.bounds
        currencySelectorWidgetContainer.addSubview(self.view)
        self.didMove(toParent: parent)
    }
}
