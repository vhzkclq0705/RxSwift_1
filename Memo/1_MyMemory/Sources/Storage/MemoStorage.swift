//
//  MemoStorage.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/03.
//

import Foundation

import RxSwift
import RxCocoa

protocol MemoStorageType {
    func getMemoList() -> BehaviorRelay<[MemoData]>
    func create(title: String?, contents: String?, imgData: Data?, regDate: Date)
    func update(memo: MemoData)
    func delete(memo: MemoData)
}

class Storage: MemoStorageType {
    
    // MARK: - Property
    
    static let shared = Storage()
    
    private var list: [MemoData] = []
    
    private lazy var memoList = BehaviorRelay<[MemoData]>(value: list)
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Func
    
    func getMemoList() -> BehaviorRelay<[MemoData]> {
        return memoList
    }
    
    func create(title: String?, contents: String?, imgData: Data?, regDate: Date) {
        let memo = MemoData(
            title: title,
            contents: contents,
            imageData: imgData,
            regdate: regDate)
        
        list.append(memo)
        
        memoList.accept(list)
    }
    
    func update(memo: MemoData, title: String?, contents: String?, imgData: Data?) {
        let updatedMemo = MemoData()
        
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updatedMemo, at: index)
        }
        
        memoList.accept(list)
    }
    
    func delete(memo: MemoData) {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
        
        memoList.accept(list)
    }
    
}
