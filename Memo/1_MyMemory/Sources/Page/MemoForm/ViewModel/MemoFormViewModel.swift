//
//  MemoFormViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/31.
//

import Foundation

import RxSwift

class MemoFormViewModel {
    
    // MARK: - Input
    
    struct Input {
        let cameraButtonDidTapEvent = PublishSubject<Void>()
        let saveButtonDidTapEvent = PublishSubject<Void>()
    }
    
    // MARK: - Output
    
    struct Output {
        let memo = PublishSubject<MemoData>()
        let showImagePicker = PublishSubject<Void>()
        let saveMemoAndPop = PublishSubject<Void>()
    }
    
    // MARK: - Property
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        bind()
    }
    
    // MARK: - Func
    
    func bind() {
        input.cameraButtonDidTapEvent
            .bind(to: output.showImagePicker)
            .disposed(by: disposeBag)
        
        input.saveButtonDidTapEvent
            .bind(to: output.saveMemoAndPop)
            .disposed(by: disposeBag)
    }
    
    func save(memo: MemoData) {
        output.memo.onNext(memo)
        output.memo.onCompleted()
    }
    
}