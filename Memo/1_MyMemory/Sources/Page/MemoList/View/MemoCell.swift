//
//  MemoCell.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

class MemoCell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var regdate: UILabel!
    @IBOutlet weak var img: UIImageView!

    // MARK: - Func
    
    func updateCell(_ data: MemoData) {
        if data.image != nil {
            self.img.image = data.image
        }
        self.subject.text = data.title
        self.contents.text = data.contents
        self.regdate.text = data.regdate!.formatToString(false)
    }

}
