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
    
    /// RxSwift를 이용한 비동기 API 호출
    private func downloadJSONWithRxSwift(_ url: String) -> Observable<String?> {
        
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴
        return Observable.create { f in
            DispatchQueue.global().async {
                let url = URL(string: url)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                
                DispatchQueue.main.async {
                    f.onNext(json)
                }
            }
            
            return Disposables.create()
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
        _ = downloadJSONWithRxSwift(self.listURL)
            .subscribe { event in
                // 해당 closure에서 순환 참조가 발생할 수 있다.
                // closure에서 self.~~~를 호출함으로써 Reference Count가 증가하기 때문이다.
                // 하지만, .completed, .error 케이스가 실행되면 closure가 닫히면서 Reference Count도 감소한다.

                switch event {
                case .next(let json):
                    self.textView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                case .completed:
                    break
                case .error:
                    break
                }
            }
    }
    
}

