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
    
    private func downloadJSON(_ url: String) -> String? {
        let url = URL(string: url)!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        
        return json
    }
    
    // MARK: - Action
    
    @IBAction func didTapLoadButton(_ sender: Any) {
        self.textView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        DispatchQueue.global().async {
            let json = self.downloadJSON(self.listURL)
            
            DispatchQueue.main.async {
                self.textView.text = json
                
                self.setVisibleWithAnimation(self.activityIndicator, false)
            }
        }
    }

}

