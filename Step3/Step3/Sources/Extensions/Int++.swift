//
//  Int++.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import Foundation

extension Int {
    
    func convertToKRW() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let str = formatter.string(from: self as NSNumber) ?? ""
        
        return "￦" + str
    }
    
}
