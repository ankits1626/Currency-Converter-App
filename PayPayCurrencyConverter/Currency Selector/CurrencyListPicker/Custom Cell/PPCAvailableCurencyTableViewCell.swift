//
//  PPCAvailableCurencyTableViewCell.swift
//  PayPayCurrencyConverter
//
//  Created by Ankit on 30/07/22.
//

import UIKit

class PPCAvailableCurencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyCodeLbl: UILabel?
    @IBOutlet weak var currencyNameLbl: UILabel?
    @IBOutlet weak var currencyFlagIvew: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
