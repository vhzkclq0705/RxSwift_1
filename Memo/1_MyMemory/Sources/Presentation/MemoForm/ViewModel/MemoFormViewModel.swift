//
//  MemoFormViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/31.
//

import UIKit

import RxSwift

protocol MemoFormViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
}

class MemoFormViewModel: MemoFormViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let cameraButtonDidTapEvent: Observable<Void>
        let saveButtonDidTapEvent: Observable<Void>
        let title: Observable<String>
        let contents: Observable<String?>
    }
    
    // MARK: - Output
    
    struct Output {
        let showImagePicker: PublishSubject<Void>
        let saveMemoAndPop: PublishSubject<Void>
        let title: PublishSubject<String>
        let contents: PublishSubject<String?>
    }
    
    // MARK: - Property

    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    private var title: String
    private var contents: String?
    private var imgData: Data?
    
    // MARK: - Init
    
    init() {
        self.storage = Storage.shared
        self.title = ""
        self.contents = nil
        self.imgData = nil
    }
    
    // MARK: - Bind
    
    func transform(input: Input) -> Output {
        let showImagePicker = PublishSubject<Void>()
        let saveMemoAndPop = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let contents = PublishSubject<String?>()
        
        input.cameraButtonDidTapEvent
            .bind(to: showImagePicker)
            .disposed(by: disposeBag)
        
        input.saveButtonDidTapEvent
            .do(onNext: { [weak self] in
                self?.saveMemo()
            })
            .bind(to: saveMemoAndPop)
            .disposed(by: disposeBag)
        
        input.title
            .filter { $0.count <= 15 }
            .do(onNext: { [weak self] in
                self?.title = $0
            })
            .bind(to: title)
            .disposed(by: disposeBag)
        
        input.contents
            .do(onNext: { [weak self] in
                self?.contents = $0
            })
            .bind(to: contents)
            .disposed(by: disposeBag)
        
        return Output(
            showImagePicker: showImagePicker,
            saveMemoAndPop: saveMemoAndPop,
            title: title,
            contents: contents)
    }
    
    // MARK: - Func
    
    func setImage(_ imgData: Data?) -> Observable<Data?> {
        self.imgData = imgData
        
        return Observable.just(imgData)
    }
    
    private func saveMemo() {
        storage.create(title: title, contents: contents, imgData: imgData)
    }

}
