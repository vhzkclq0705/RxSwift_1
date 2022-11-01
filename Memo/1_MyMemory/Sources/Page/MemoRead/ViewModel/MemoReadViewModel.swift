//
//  MemoReadViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/01.
//

import Foundation

import RxSwift

class MemoReadViewModel {
    
    // MARK: - Ouput
    
    struct Output {
        let memo: Observable<MemoData>
    }
    
    // MARK: - Property
    
    let output: Output
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(_ memo: MemoData) {
        output = Output(memo: Observable.just(memo))
    }
    
}
