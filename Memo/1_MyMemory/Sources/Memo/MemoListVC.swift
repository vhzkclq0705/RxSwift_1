//
//  MemoListVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/26.
//

import UIKit

class MemoListVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var tableVIew: UITableView!
    
    // MARK: - Property
    
    var memoList: [MemoData] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "create" {
            guard let vc = segue.destination as? MemoFormVC else {
                return
            }
            
            vc.saveHandler = { memoData in
                self.memoList.append(memoData)
                self.tableVIew.reloadData()
                print(self.memoList)
            }
        }
    }

    // MARK: - Func
    
    func configureVC() {
        tableVIew.delegate = self
        tableVIew.dataSource = self
    }

}

// MARK: - TableView DataSource & Delegate

extension MemoListVC: UITableViewDataSource,
                      UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return memoList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let memo = memoList[indexPath.row]
        let cellId = memo.image == nil ? "memoCell" : "memoCellWithImage"
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId) as? MemoCell else {
            return UITableViewCell()
        }
        
        cell.updateCell(memo)

        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        guard let vc = self.storyboard?.instantiateViewController(
            withIdentifier: "MemoReadVC") as? MemoReadVC else {
            return
        }
     
        let memo = memoList[indexPath.row]
        vc.param = memo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
