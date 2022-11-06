//
//  MemoListViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/26.
//

import Foundation

import RxSwift
import RxCocoa

protocol MemoListViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
}

class MemoListViewModel: MemoListViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let createButtonDidTapEvent: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let memoList: BehaviorRelay<[MemoData]>
        let showMemoFormVC: Signal<Void>
    }
    
    // MARK: - Property
    
    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        self.storage = Storage.shared
        storage.load()
    }
    
    // MARK: - Bind
    
    func transform(input: Input) -> Output {
        let memoList = storage.getMemoList()
        
        let showMemoFormVC = input.createButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            memoList: memoList,
            showMemoFormVC: showMemoFormVC)
    }
    
}
