//
//  Menu.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import Foundation

/// TableView에 넣어줄 데이터 모델
struct Menu: Decodable {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
    
}
