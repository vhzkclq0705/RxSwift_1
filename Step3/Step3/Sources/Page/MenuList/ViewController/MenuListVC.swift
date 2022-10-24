//
//  MenuListVC.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import UIKit

import RxSwift
import RxCocoa

class MenuListVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // MARK: - Property
    
    let viewModel = MenuListViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    // MARK: - Func
    
    private func configureVC() {
        configureViewModel()
        
    }
    
    private func configureViewModel() {
        self.viewModel.menus
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.tableView.rx.items(
                cellIdentifier: "Cell",
                cellType: Cell.self)) { index, item, cell in
                    cell.updateCell(item)
                    
                    cell.countChange = { [weak self] num in
                        self?.viewModel.changeCount(item, num)
                    }
                }
                .disposed(by: self.disposeBag)
        
        self.viewModel.itemsCount
            .map { "\($0)" }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.itemCountLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.totalPrice
            .map { $0.convertToKRW() }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.totalPriceLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "order" {
           guard let vc = segue.destination as? OrderListVC else {
               return
           }
        }
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        self.viewModel.clearAllItemSelections()
    }
    
    @IBAction func didTapOrderButton(_ sender: Any) {
        
    }

}
