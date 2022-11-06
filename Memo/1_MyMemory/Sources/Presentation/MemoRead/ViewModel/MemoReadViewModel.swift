//
//  MemoReadViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/01.
//

import Foundation

import RxSwift

protocol MemoReadViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
}

class MemoReadViewModel: MemoReadViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let updateButtonDidTapEvent: Observable<Void>
        let deleteButtonDidTapEvent: Observable<Void>
        let cameraButtonDidTapEvent: Observable<Void>
        let completeButtonDidTapEvent: Observable<Void>
        let title: Observable<String>
        let contents: Observable<String?>
    }
    
    // MARK: - Ouput
    
    struct Output {
        let title: Observable<String>
        let contents: Observable<String?>
        let date: Observable<String>
        let imgData: Observable<Data?>
        let update: Observable<Void>
        let complete: Observable<Void>
        let delete: Observable<Void>
        let camera: Observable<Void>
    }
    
    // MARK: - Property
    
    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    private var memo: Observable<MemoData>
    private var original: MemoData!
    private var title: String
    private var contents: String?
    private var imgData: Data?
    
    // MARK: - Init
    
    init(_ memo: MemoData) {
        self.storage = Storage.shared
        self.memo = Observable.just(memo)
        self.original = memo
        self.title = ""
        self.contents = nil
        self.imgData = nil
    }
    
    // MARK: - Bind
    
    func transform(input: Input) -> Output {
        memo.subscribe(onNext: {
            self.original = $0
        })
        .disposed(by: disposeBag)
        
        input.title
            .subscribe(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
            
        input.contents
            .subscribe(onNext: { [weak self] in
                self?.contents = $0
            })
            .disposed(by: disposeBag)
        
        let title = memo
            .map { $0.title }
 
        let contents = memo
            .map { $0.contents }
        
        let imgData = memo
            .map { $0.imageData }
        
        let date = memo
            .map { $0.regdate.formatToString(true) }
        
        let update = input.updateButtonDidTapEvent
                
        let complete = input.completeButtonDidTapEvent
        
        let deleteAlert = input.deleteButtonDidTapEvent
        
        let camera = input.cameraButtonDidTapEvent
        
        return Output(
            title: title,
            contents: contents,
            date: date,
            imgData: imgData,
            update: update,
            complete: complete,
            delete: deleteAlert,
            camera: camera)
    }
    
    // MARK: - Func
    
    func setImage(_ imgData: Data?) -> Observable<Data?> {
        self.imgData = imgData
        
        return Observable.just(imgData)
    }
    
    func updateMemo() {
        storage.update(memo: original, title: title, contents: contents, imgData: imgData)
    }
    
}
