//
//  PPCCurrencyListViewController.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import UIKit
import KUIPopOver
import SDWebImage

/**
 This defines interfaces for currency picker, as of now the only confirming class will be PPCCurrencyListViewController
 */
public protocol PPCCurrencyListViewProtocol : AnyObject{
    func showCurrencyPicker(_ availableCurencies: [PPCAvailableCurrencyProtocol])
    /**
     this is a completion block used to pass a selected currency from the list view to the main widget
     note: we can use a delegation pattern as well but since we have a single action thus using a completion block
     */
    var currencySelectionCompletionBlock : (((PPCAvailableCurrencyProtocol)) -> Void)? {set get}
}

/**
 This class displays a list of currencies and is in an integral part of curency selection widget
 the list is presented in a popover
 This class also interatcs with currency provider class to provide flags
 */
class PPCCurrencyListViewController: UIViewController, KUIPopOverUsable {
    //public ivars
    public var contentSize: CGSize = CGSize(width: 252, height: 354)
    public var currencySelectionCompletionBlock : (((PPCAvailableCurrencyProtocol)) -> Void)?

    //private ivars
    private var availableCurrencies: [PPCAvailableCurrencyProtocol]!{
        didSet{
            currencyListTableVew?.reloadData()
        }
    }
    
    private lazy var countryCodeProvider: PPCCountryCodeProvider = {
        return PPCCountryCodeProvider()
    }()
    
    //private IBOutlets
    @IBOutlet private weak var currencyListTableVew: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnViewDidLoad()
    }
    
    func passSelectedCurrencyToListener(_ selectedCurrency : PPCAvailableCurrencyProtocol){
        dismissPopover(animated: true) {
            self.currencySelectionCompletionBlock?(selectedCurrency)
        }
    }
}

extension PPCCurrencyListViewController : PPCCurrencyListViewProtocol{
    func showCurrencyPicker(_ availableCurencies: [PPCAvailableCurrencyProtocol]){
        self.availableCurrencies = availableCurencies
    }
}


extension PPCCurrencyListViewController{
    private func setupOnViewDidLoad(){
        setupCurrentTableView()
    }
    
    private func setupCurrentTableView(){
        currencyListTableVew?.register(
            UINib(nibName: "PPCAvailableCurencyTableViewCell", bundle: nil),
            forCellReuseIdentifier: "cell"
        )
        currencyListTableVew?.dataSource = self
        currencyListTableVew?.delegate = self
    }
}

extension PPCCurrencyListViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currencyCell = cell as! PPCAvailableCurencyTableViewCell
        let currency = availableCurrencies[indexPath.row]
        currencyCell.currencyCodeLbl?.text = currency.presentationCurrencyCode
        currencyCell.currencyNameLbl?.text = currency.presentationCurrencyName
        var flagUrl : URL?
        if let countryCode = countryCodeProvider.getCountryCode(currency.presentationCurrencyCode){
            flagUrl = URL(string: "https://countryflagsapi.com/png/\(countryCode)")
        }
        currencyCell.currencyFlagIvew?.sd_setImage(with: flagUrl)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passSelectedCurrencyToListener(availableCurrencies[indexPath.row])
    }
}
