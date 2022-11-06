//
//  MemoFormViewModel.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/10/31.
//

import UIKit

import RxSwift
import RxCocoa

protocol MemoFormViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
    var title: String { get set }
    var contents: String? { get set }
    var imgData: Data? { get set }
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
        let showImagePicker: Signal<Void>
        let saveMemoAndPop: Signal<Bool>
        let title: Signal<String>
        let titleLength: Observable<Bool>
    }
    
    // MARK: - Property

    var storage: MemoStorageType
    var disposeBag = DisposeBag()
    var title: String
    var contents: String?
    var imgData: Data?
    
    // MARK: - Init
    
    init() {
        self.storage = Storage.shared
        self.title = ""
        self.contents = nil
        self.imgData = nil
    }
    
    // MARK: - Bind
    
    func transform(input: Input) -> Output {
        let inputTitle = input.title.share()
        
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
        
        let title = inputTitle
            .asSignal(onErrorJustReturn: "")
        
        let titleLength = inputTitle
            .map { $0.count > 15 }
        
        let showImagePicker = input.cameraButtonDidTapEvent
            .asSignal(onErrorJustReturn: ())
        
        let saveMemoAndPop = input.saveButtonDidTapEvent
            .map { [weak self] in
                self?.title == ""
            }
            .asSignal(onErrorJustReturn: false)
                
        return Output(
            showImagePicker: showImagePicker,
            saveMemoAndPop: saveMemoAndPop,
            title: title,
            titleLength: titleLength)
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
