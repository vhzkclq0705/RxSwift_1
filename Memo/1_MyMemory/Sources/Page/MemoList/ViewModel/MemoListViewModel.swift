//
//  MemoListViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/26.
//

import Foundation

import RxSwift
import RxRelay

class MemoListViewModel {
    
    // MARK: - Input
    
    struct Input {
        let createButtonDidTapEvent = PublishSubject<Void>()
    }
    
    // MARK: - Output
    
    struct Output {
        let memoList = BehaviorRelay<[MemoData]>(value: [])
        let showMemoFormVC = PublishSubject<Void>()
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        bind()
    }
    
    // MARK: - Bind
    
    func bind() {
        input.createButtonDidTapEvent
            .bind(to: output.showMemoFormVC)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Func
    
    func addMemo(memo: MemoData) {
        var memoList = output.memoList.value
        let lastIdx = memoList.last?.memoIdx ?? -1
        let memo = MemoData(
            memoIdx: lastIdx + 1,
            title: memo.title,
            contents: memo.contents,
            image: memo.image,
            regdate: memo.regdate)
        
        memoList.append(memo)
        output.memoList.accept(memoList)
    }
    
}
