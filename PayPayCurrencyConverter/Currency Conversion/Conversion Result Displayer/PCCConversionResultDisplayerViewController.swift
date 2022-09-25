//
//  PCCConversionResultDisplayerViewController.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 31/07/22.
//

import UIKit

/**
 Interface for conversion displayer
 */
protocol PCCConversionResultDisplayerProtocol{
    func showConversionResults(_ conversions : [PPCCurrencyConversionProtocol])
}

/**
 View controller responsible to show the conversion results
 */
class PCCConversionResultDisplayerViewController: UIViewController {
    
    //private ivars
    private var conversions : [PPCCurrencyConversionProtocol]!
    private lazy var countryCodeProvider: PPCCountryCodeProvider = {
        return PPCCountryCodeProvider()
    }()
    //private IBoutlets
    @IBOutlet private weak var conversionCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnViewDidLoad()
    }
}

extension PCCConversionResultDisplayerViewController : PCCConversionResultDisplayerProtocol{
    func showConversionResults(_ conversions : [PPCCurrencyConversionProtocol]){
        self.conversions = conversions
        conversionCollectionView?.reloadData()
    }
}

extension PCCConversionResultDisplayerViewController{
    
    private func setupOnViewDidLoad(){
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        conversionCollectionView?.register(
            UINib(nibName: "PCCCurrencyConversionCollectionViewCell", bundle: Bundle(for: PCCCurrencyConversionCollectionViewCell.self)),
            forCellWithReuseIdentifier: "cell"
        )
        conversionCollectionView?.dataSource = self
        conversionCollectionView?.delegate = self
    }
}

extension PCCConversionResultDisplayerViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let conversionDetailCell = cell as! PCCCurrencyConversionCollectionViewCell
        let conversion = conversions[indexPath.row]
        conversionDetailCell.conversionDetailContainer?.curvedCornerControl()
        conversionDetailCell.conversionDetailLbl?.text = conversion.presentableCovertedAmount
        conversionDetailCell.currencyFullNameLbl?.text = countryCodeProvider.getCurrencyName(conversion.currency.presentationCurrencyCode)
        conversionDetailCell.currencyFullNameLbl?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        var flagUrl : URL?
        if let countryCode = countryCodeProvider.getCountryCode(conversion.currency.presentationCurrencyCode){
            flagUrl = URL(string: "https://countryflagsapi.com/png/\(countryCode)")
        }
        conversionDetailCell.currencyFlagIVew?.curvedCornerControl()
        conversionDetailCell.currencyFlagIVew?.sd_setImage(with: flagUrl)
    }
    
}

extension PCCConversionResultDisplayerViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
    }
}

