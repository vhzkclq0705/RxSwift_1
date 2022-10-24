//
//  MenuListVC.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import UIKit

class MenuListVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    // MARK: - Property
    
    var itemCount: Int = 0 {
        didSet {
            if self.itemCount < 0 {
                self.itemCount = 0
            }
            
            self.itemCountLabel.text = "\(self.itemCount) Items"
        }
        willSet {
            self.itemCount += newValue
        }
    }
    
    var totalCost: Int = 0 {
        didSet {
            if self.totalCost < 0 {
                self.totalCost = 0
            }
            
            self.totalCostLabel.text = self.totalCost.convertToString()
        }
        willSet {
            self.totalCost += newValue
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    // MARK: - Func
    
    private func configureVC() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func updateTotalCost(_ cost: Int, _ isPlus: Bool) {
        self.totalCost = isPlus ? self.totalCost + cost : self.totalCost - cost
        self.itemCount = isPlus ? self.itemCount + 1 : self.itemCount - 1
    }
    
    // MARK: - Action
    
    @IBAction func didTapClearButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapOrderButton(_ sender: Any) {
        
    }

}

// MARK: - TableView delegate & dataSource

extension MenuListVC: UITableViewDelegate,
                          UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return 20
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        cell.updateCell(indexPath.row)
        cell.plusButtonTapHandler = { cost in
            self.updateTotalCost(cost, true)
        }
        cell.minusButtonTapHandler = { cost in
            self.updateTotalCost(cost, false)
        }
        
        return cell
    }
    
}
