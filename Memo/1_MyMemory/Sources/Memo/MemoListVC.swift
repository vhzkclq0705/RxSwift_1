//
//  MemoListVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/26.
//

import UIKit

import RxSwift
import RxCocoa

class MemoListVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // var memoList: [MemoData] = []
    let memoList = BehaviorRelay<[MemoData]>(value: [])
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "create",
           let vc = segue.destination as? MemoFormVC {
            vc.saveHandler = {
                var memoList = self.memoList.value
                memoList.append($0)
                self.memoList.accept(memoList)
            }
        }
    }

    // MARK: - Func
    
    func bindUI() {
//        tableView.delegate = self
//        tableView.dataSource = self
        bindTableView()
    }
    
    func bindTableView() {
        memoList
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tableView, row, item -> UITableViewCell in
                let id = item.image != nil ? "memoCellWithImage" : "memoCell"
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: id,
                    for: IndexPath(row: row, section: 0)) as? MemoCell else {
                    return UITableViewCell()
                }
                cell.updateCell(item)
            
                return cell
            }
            .disposed(by: disposeBag)
    }
                

}

// MARK: - TableView DataSource & Delegate

//extension MemoListVC: UITableViewDataSource,
//                      UITableViewDelegate {
//
//    func tableView(
//        _ tableView: UITableView,
//        numberOfRowsInSection section: Int)
//    -> Int
//    {
//        return memoList.count
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath)
//    -> UITableViewCell
//    {
//        let memo = memoList[indexPath.row]
//        let cellId = memo.image == nil ? "memoCell" : "memoCellWithImage"
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: cellId) as? MemoCell else {
//            return UITableViewCell()
//        }
//
//        cell.updateCell(memo)
//
//        return cell
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath)
//    {
//        guard let vc = self.storyboard?.instantiateViewController(
//            withIdentifier: "MemoReadVC") as? MemoReadVC else {
//            return
//        }
//
//        let memo = memoList[indexPath.row]
//        vc.param = memo
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}
