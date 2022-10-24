//
//  Response.swift
//  Step3
//
//  Created by 권오준 on 2022/10/25.
//

import Foundation

/// API를 호출하면 받아오는 데이터 모델 리스트
struct Response: Decodable {
    var menus: [MenuItem]
}
