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
    
}

class MemoListViewModel: MemoListViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let createButtonDidTapEvent: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let memoList: BehaviorRelay<[MemoData]>
        let showMemoFormVC: PublishSubject<Void>
    }
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    // MARK: - Bind
    
    func transform(input: Input) -> Output {
        let memoList = BehaviorRelay<[MemoData]>(value: [MemoData(memoIdx: 0, title: "zz", contents: "ss", regdate: Date())])
        let showMemoFormVC = PublishSubject<Void>()
        
        input.createButtonDidTapEvent
            .bind(to: showMemoFormVC)
            .disposed(by: disposeBag)
        
        return Output(
            memoList: memoList,
            showMemoFormVC: showMemoFormVC)
    }
    
}
