//
//  ViewModelType.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/01.
//

import Foundation

import RxSwift

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
}
