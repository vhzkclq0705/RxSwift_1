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
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    // MARK: - Property
    
    let viewModel = MemoListViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureTableViewDelegate()
    }
    
    // MARK: - Bind
    
    func bindViewModel() {
        
        let input = MemoListViewModel.Input(
            createButtonDidTapEvent: createButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.memoList
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tableView, row, item in
                let id = item.imageData != nil ? "memoCellWithImage" : "memoCell"
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: id,
                    for: IndexPath(row: row, section: 0)) as? MemoCell else {
                    return UITableViewCell()
                }
                
                cell.memo.onNext(item)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        output.showMemoFormVC
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "create", sender: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    func configureTableViewDelegate() {
        tableView.rx.modelSelected(MemoData.self)
            .subscribe(onNext: { [weak self] memo in
                guard let vc = self?.storyboard?.instantiateViewController(
                    withIdentifier: "MemoReadVC") as? MemoReadVC else {
                    return
                }
                vc.viewModel = MemoReadViewModel(memo)
                
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
