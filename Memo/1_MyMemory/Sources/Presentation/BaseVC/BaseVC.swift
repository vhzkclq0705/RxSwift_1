//
//  BaseVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/06.
//

import UIKit

import RxSwift

class BaseVC: UIViewController {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
