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
    @IBOutlet weak var costLabel: UILabel!
    
    // MARK: - Property
    
    var cost: Int = 0
    var count: Int = 0
    var plusButtonTapHandler: ((Int) -> Void)?
    var minusButtonTapHandler: ((Int) -> Void)?
    
    // MARK: - Func
    
    func updateCell(_ index: Int) {
        self.nameLabel.text = "MENU \(index)"
        self.cost = index * 100
        self.costLabel.text = "\(self.cost)"
    }
    
    private func updateCount(_ isPlus: Bool) {
        self.count = isPlus ? self.count + 1 : self.count - 1
        if self.count < 0 {
            self.count = 0
        }
        
        self.countLabel.text = "(\(self.count))"
    }
    
    
    // MARK: - Action
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        updateCount(true)
        self.plusButtonTapHandler?(self.cost)
    }
    
    @IBAction func didTapMinusButton(_ sender: Any) {
        updateCount(false)
        self.minusButtonTapHandler?(self.cost)
    }
    
    
}
