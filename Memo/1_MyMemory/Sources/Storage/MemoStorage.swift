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
    func create(title: String, contents: String?, imgData: Data?)
    func update(memo: MemoData, title: String, contents: String?, imgData: Data?)
    func delete(memo: MemoData)
    func save()
    func load()
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
    
    func create(title: String, contents: String?, imgData: Data?) {
        let memo = MemoData(
            title: title,
            contents: contents,
            imageData: imgData)
        
        list.append(memo)
        save()
        
        memoList.accept(list)
    }
    
    func update(memo: MemoData, title: String, contents: String?, imgData: Data?) {
        let updatedMemo = MemoData(
            original: memo,
            title: title,
            contents: contents,
            imageData: imgData)
        
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updatedMemo, at: index)
        }
        
        save()
        
        memoList.accept(list)
    }
    
    func delete(memo: MemoData) {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
        
        save()
        
        memoList.accept(list)
    }
    
    func save() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(list),
            forKey: "MemoList")
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "MemoList") else {
            return
        }
        
        list = (try? PropertyListDecoder().decode([MemoData].self, from: data)) ?? []
        
        memoList.accept(list)
    }
    
}
