//
//  MemoReadViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

protocol MemoReadViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
    var memo: Observable<MemoData> { get set }
    var original: MemoData! { get set }
    var title: String { get set }
    var contents: String? { get set }
    var imgData: Data? { get set }
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
        let title: Signal<String>
        let titleLength: Observable<Bool>
        let contents: Signal<String?>
        let date: Signal<String>
        let imgData: Signal<Data?>
        let update: Signal<Void>
        let complete: Signal<Void>
        let delete: Signal<Void>
        let camera: Signal<Void>
    }
    
    // MARK: - Property
    
    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    var memo: Observable<MemoData>
    var original: MemoData!
    var title: String
    var contents: String?
    var imgData: Data?
    
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
        let inputTitle = input.title.share()
        
        memo.subscribe(onNext: {
            self.original = $0
        })
        .disposed(by: disposeBag)
        
        inputTitle
            .subscribe(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
            
        input.contents
            .subscribe(onNext: { [weak self] in
                self?.contents = $0
            })
            .disposed(by: disposeBag)
        
        let titleLength = inputTitle
            .map { $0.count > 15 }
        
        let title = memo
            .map { $0.title }
            .asSignal(onErrorJustReturn: "")
 
        let contents = memo
            .map { $0.contents }
            .asSignal(onErrorJustReturn: nil)
        
        let imgData = memo
            .map { $0.imageData }
            .asSignal(onErrorJustReturn: nil)
        
        let date = memo
            .map { $0.regdate.formatToString(true) }
            .asSignal(onErrorJustReturn: Date().formatToString(true))
        
        let update = input.updateButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
                
        let complete = input.completeButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let deleteAlert = input.deleteButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let camera = input.cameraButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
        
        return Output(
            title: title,
            titleLength: titleLength,
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
