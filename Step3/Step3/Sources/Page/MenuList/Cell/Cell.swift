//
//  Cell.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import UIKit

class Cell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Property

    var countChange: ((Int) -> Void)?
    
    // MARK: - Func
    
    func updateCell(_ menu: Menu) {
        self.nameLabel.text = "\(menu.name)"
        self.countLabel.text = "\(menu.count)"
        self.priceLabel.text = "\(menu.price)"
    }
    
    
    // MARK: - Action
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        self.countChange?(1)
    }
    
    @IBAction func didTapMinusButton(_ sender: Any) {
        self.countChange?(-1)
    }
    
    
}
