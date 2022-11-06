//
//  UIViewController++.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/11/01.
//

import UIKit

extension UIViewController {
    
    func presentAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "제목을 입력해주세요.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
}
