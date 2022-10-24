//
//  ViewController.swift
//  Step1
//
//  Created by 권오준 on 2022/10/20.
//

import UIKit

import RxSwift
import SwiftyJSON

class ViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Property
    
    private let listURL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"
    // Disposable 객체들을 담을 수 있는 DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    // MARK: - Func
    
    private func configureVC() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    private func setVisibleWithAnimation(_ v: UIActivityIndicatorView?, _ s: Bool) {
        guard let v = v else { return }
        
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            if s {
                v?.startAnimating()
            } else {
                v?.stopAnimating()
            }
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // completion: @escaping (String?) -> Void ... completion(json)
    // completion: ((String?) -> Void)? ... completion?(json)
    // 위 두 코드는 같다.
    
    /// Escaping closure를 이용한 비동기 API 호출
    private func downloadJSONWithEscapingClosure(
        _ url: String,
        completion: @escaping (String?) -> Void)
    {
        DispatchQueue.global().async {
            let url = URL(string: url)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)
            
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
    
    // MARK: RxSwift
    
    // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴
    // 2. Observerble로 오는 데이터를 받아서 처리하는 방법
    
    // Observable의 생명 주기

    // 1. Create
    // 2. Subscribe
    // 3. onNext
    // ---- end ----
    // 4. onCompleted / onError
    // 5. Disposed
    
    /// RxSwift를 이용한 비동기 API 호출
    private func downloadJSONWithRxSwift(_ url: String) -> Observable<String?> {
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴
        return Observable.create() { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { data, _, err in
                guard err == nil else {
                    // 에러가 발생하면 .onError를 통해 에러 전달
                    emitter.onError(err!)
                    return
                }

                // 데이터가 준비가 되면 .onNext를 통해 데이터 전달
                if let data = data,
                   let json = String(data: data, encoding: .utf8) {
                    emitter.onNext(json)
                }

                // 데이터가 준비가 되지 않으면 onCompleted를 통해 종료
                emitter.onCompleted()
            }

            task.resume()

            return Disposables.create() {
                task.cancel()
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func didTapLoadButton(_ sender: Any) {
        self.textView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

        // Escaping closure
//        downloadJSONWithEscapingClosure(self.listURL) { json in
//            self.textView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//        }

        // RxSwift
        // 2. Observerble로 오는 데이터를 받아서 처리하는 방법
        // 해당 메소드를 변수로 받아 disposable을 사용하여 종료할 수 있다.
        
        // 기본 사용법
//        _ = downloadJSONWithRxSwift(self.listURL)
//            .debug() // 작업 로그를 출력
//            .subscribe { event in
//                // 해당 closure에서 순환 참조가 발생할 수 있다.
//                // closure에서 self.~~~를 호출함으로써 Reference Count가 증가하기 때문이다.
//                // 하지만, .completed, .error가 실행되면 closure가 닫히면서 Reference Count도 감소한다.
//
//                switch event {
//                case .next(let json):
//                    DispatchQueue.main.async {
//                        self.textView.text = json
//                        self.setVisibleWithAnimation(self.activityIndicator, false)
//                    }
//                case .completed:
//                    break
//                case .error:
//                    break
//                }
//            }
        
        // 가독성 있게 줄인 후
        _ = downloadJSONWithRxSwift(self.listURL)
            .observe(on: MainScheduler.instance) // operator, DispatchQueue.main.async과 동일
            .subscribe(onNext: { json in
                self.textView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            .disposed(by: self.disposeBag)
        
        // operator를 사용해 글자 수 textView에 전달
//        _ = downloadJSONWithRxSwift(self.listURL)
//            .map { json in json?.count ?? 0 }       // operator, json데이터의 글자 수 세기
//            .filter { cnt in cnt > 0 }              // operator, 글자 수가 0보다 클 경우에만 아래 코드 실행
//            .map { "\($0)" }                        // operator, 데이터(글자 수)를 String으로 변경
//            .observe(on: MainScheduler.instance)    // operator
//            .subscribe(onNext: { json in
//                self.textView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            })
    }
    
}

