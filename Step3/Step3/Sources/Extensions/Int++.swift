//
//  Int++.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import Foundation

extension Int {
    
    func convertToString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
}
