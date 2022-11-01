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
    
    // MARK: - func
    
    func bind() {
        input.createButtonDidTapEvent
            .bind(to: output.showMemoFormVC)
            .disposed(by: disposeBag)
    }
    
}
