//
//  Date++Extensions.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import Foundation

extension Date {
    
    func formatToString(_ read: Bool) -> String {
        let format = read ? "dd일 HH:mm분에 작성됨" : "yyyy-MM-dd HH:mm:ss"
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
}
