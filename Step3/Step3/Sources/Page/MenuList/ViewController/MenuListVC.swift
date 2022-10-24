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
        // UI 작업은 observe()과 bind() 대신 asDriver()와 drive()를 쓰는 것이 좋다.
        // 이유: UI에 데이터를 바인딩하는 과정에서 에러가 나면 더이상 동작하지 않는데, 에러처리를 따로 해줄 수 있다.
        // 또한, drive()는 메인쓰레드에서 작동한다.
        self.viewModel.menus
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(
                cellIdentifier: "Cell",
                cellType: Cell.self)) { index, item, cell in
                    cell.updateCell(item)
                    
                    cell.countChange = { [weak self] num in
                        self?.viewModel.changeCount(item, num)
                    }
                }
                .disposed(by: self.disposeBag)
        
        self.viewModel.itemsCount
            .map { "\($0) Items" }
            .asDriver(onErrorJustReturn: "")
            .drive(self.itemCountLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.totalPrice
            .map { $0.convertToKRW() }
            .asDriver(onErrorJustReturn: "")
            .drive(self.totalPriceLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "order" {
//           guard let vc = segue.destination as? OrderListVC else {
//               return
//           }
//        }
//    }
    
    // MARK: - Action
    
    @IBAction func didTapClearButton(_ sender: Any) {
        self.viewModel.clearAllItemSelections()
    }
    
    @IBAction func didTapOrderButton(_ sender: Any) {
        self.viewModel.onOrder()
    }

}
