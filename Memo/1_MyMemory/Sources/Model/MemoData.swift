//
//  MemoData.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

struct MemoData: Codable, Equatable {
    var title: String
    var contents: String?
    var imageData: Data?
    var regdate: Date
    var identifier: Int
    
    // 메모 생성용
    init(
        title: String,
        contents: String?,
        imageData: Data?,
        regdate: Date = Date())
    {
        self.title = title
        self.contents = contents
        self.imageData = imageData
        self.regdate = regdate
        self.identifier = Int(Date().timeIntervalSince1970)
    }
    
    // 메모 업데이트용
    init(
        original: MemoData,
        title: String,
        contents: String?,
        imageData: Data?,
        regdate: Date = Date())
    {
        self = original
        self.title = title
        self.contents = contents
        self.imageData = imageData
        self.regdate = regdate
        self.identifier = original.identifier
    }
}
