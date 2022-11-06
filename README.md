# RxSwift_1
RxSwift 연습 Repository

## Step1
- 유튜브 곰튀김님 강의 보면서 연습한 프로젝트
- RxSwift와 URLSession을 이용하여 비동기로 API 데이터를 받아오기
- Observable과 Operator, Event의 3가지 등 완전 기초 연습

## Step3
- 유튜브 곰튀김님 강의 보면서 연습한 프로젝트
- RxSwift와 URLSession을 이용하여 비동기로 API 데이터를 받아오기
- RxSwift + MVVM패턴 연습
- 받아온 API 데이터를 RxSwift를 이용해 TableView에 Bind
- TableView Cell의 버튼을 통해 총 아이템의 갯수와 가격을 RxSwift를 통해 변경
- RxCocoa를 이용해 UI 컴포넌트 바인딩 하기
- Operator의 사용법(map, filter), Behavior(Publish)Subject, Behavior(Publish)Relay, Driver 연습

## Memo
- RxSwift, RxCocoa를 사용하여 메모장 구현(CRUD)
- CleanArchitecture - RxSwift에서 찾아본 ViewModel의 Input, Output 형식으로 바인딩
- protocol을 활용하여 각 ViewModel과 Storage의 의존성 주입 문제 해결 연습   
(다른 강의와 같이 하려 했으나, Swift 5.7버전부터 생긴 'any' 키워드에 대해 잘 몰라서 정확하게 구현 실패)
- Observable과 Observer, Signal, Driver 등 RxSwift와 RxCocoa의 더 많은 연산자와 이론에 대해 알게됨
- 적용한 ViewModel의 형태와 바인딩 메소드

<details>
    <summary> MemoFormViewModel </summary>
    <div markdown="1">
  
 ```Swift
 protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
}

protocol MemoFormViewModelType: ViewModelType {
    var storage: MemoStorageType { get }
    var title: String { get set }
    var contents: String? { get set }
    var imgData: Data? { get set }
}

final class MemoFormViewModel: MemoFormViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let cameraButtonDidTapEvent: Observable<Void>
        let saveButtonDidTapEvent: Observable<Void>
        let imageDeleteButtonDidTapEvent: Observable<Void>
        let title: Observable<String>
        let contents: Observable<String?>
    }
    
    // MARK: - Output
    
    struct Output {
        let showImagePicker: Signal<Void>
        let saveMemoAndPop: Signal<Bool>
        let imageDelete: Signal<Void>
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
        
        let imageDelete = input.imageDeleteButtonDidTapEvent
            .do(onNext: { [weak self] in
                self?.imgData = nil
            })
            .asSignal(onErrorJustReturn: ())
                
        return Output(
            showImagePicker: showImagePicker,
            saveMemoAndPop: saveMemoAndPop,
            imageDelete: imageDelete,
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
 
 ```
  </div>
</details>


<details>
    <summary> MemoFormVC </summary>
    <div markdown="2">
    
```Swift

final class MemoFromVC: BaseVC {
    
    // 중략
    
    private let viewModel = MemoFormViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        bindViewModel()
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = MemoFormViewModel.Input(
            cameraButtonDidTapEvent: cameraButton.rx.tap.asObservable(),
            saveButtonDidTapEvent: saveButton.rx.tap.asObservable(),
            imageDeleteButtonDidTapEvent: imageDeleteButton.rx.tap.asObservable(),
            title: titleTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            contents: contentsTextView.rx.text.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.title
            .emit(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
        
        output.titleLength
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.titleTextField.deleteBackward()
                }
            })
            .disposed(by: disposeBag)
        
        output.showImagePicker
            .emit(onNext: { [weak self] in
                self?.pickImage()
            })
            .disposed(by: disposeBag)
        
        output.saveMemoAndPop
            .emit(onNext: { [weak self] in
                self?.validateSave($0)
            })
            .disposed(by: disposeBag)
        
        output.imageDelete
            .emit(onNext: { [weak self] in
                self?.imageView.image = nil
            })
            .disposed(by: disposeBag)
    }
    
```
    
  </div>
</details>
