//
//  MemoFormViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/31.
//

import Foundation

import RxSwift

protocol MemoFormViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
}

class MemoFormViewModel: MemoFormViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let cameraButtonDidTapEvent: Observable<Void>
        let saveButtonDidTapEvent: Observable<(String, String?, Data?)>
    }
    
    // MARK: - Output
    
    struct Output {
        let showImagePicker: PublishSubject<Void>
        let saveMemoAndPop: PublishSubject<Void>
    }
    
    // MARK: - Property

    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        self.storage = Storage.shared
    }
    
    // MARK: - Bind
    
    func bind() {
//        input.cameraButtonDidTapEvent
//            .bind(to: output.showImagePicker)
//            .disposed(by: disposeBag)
//
//        input.saveButtonDidTapEvent
//            .bind(to: output.saveMemoAndPop)
//            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let showImagePicker = PublishSubject<Void>()
        let saveMemoAndPop = PublishSubject<Void>()
        
        input.cameraButtonDidTapEvent
            .bind(to: showImagePicker)
            .disposed(by: disposeBag)
        
        input.saveButtonDidTapEvent
            .do(onNext: { [weak self] title, contents, imgData in
                self?.storage.create(title: title, contents: contents, imgData: imgData)
            })
            .map { _ in () }
            .bind(to: saveMemoAndPop)
            .disposed(by: disposeBag)
        
        return Output(
            showImagePicker: showImagePicker,
            saveMemoAndPop: saveMemoAndPop)
    }
    
    // MARK: - Func
    
//    func saveMemo(title: String?, contents: String?, imgData: Data?, date: Date?) {
//        let memo = MemoData(title: title, contents: contents, imageData: imgData, regdate: date)
//
//        output.memo.onNext(memo)
//        output.memo.onCompleted()
//    }
    
}
