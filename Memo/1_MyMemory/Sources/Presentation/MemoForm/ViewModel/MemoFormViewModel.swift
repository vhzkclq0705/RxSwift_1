//
//  MemoFormViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/31.
//

import UIKit

import RxSwift
import RxRelay

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
        let showAlert: PublishSubject<Void>
        let title: PublishSubject<String>
        let contents: PublishRelay<String?>
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
        let showAlert = PublishSubject<Void>()
        let title = PublishSubject<String>()
        let contents = PublishRelay<String?>()
        
        input.cameraButtonDidTapEvent
            .bind(to: showImagePicker)
            .disposed(by: disposeBag)
        
        input.saveButtonDidTapEvent
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.title == "" ? showAlert.onNext(()) : saveMemoAndPop.onNext(())
            })
            .disposed(by: disposeBag)
                
        input.title
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
            showAlert: showAlert,
            title: title,
            contents: contents)
    }
    
    // MARK: - Func
    
    func setImage(_ imgData: Data?) -> Observable<Data?> {
        self.imgData = imgData
        
        return Observable.just(imgData)
    }
    
    func saveMemo() {
        storage.create(title: title, contents: contents, imgData: imgData)
    }

}
