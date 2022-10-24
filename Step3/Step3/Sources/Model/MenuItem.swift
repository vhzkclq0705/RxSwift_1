//
//  MenuItem.swift
//  Step3
//
//  Created by 권오준 on 2022/10/25.
//

import Foundation

/// API를 호출했을 때 받는 데이터 모델
struct MenuItem: Decodable {
    var name: String
    var price: Int
}
