//
//  MemoCell.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift

final class MemoCell: UITableViewCell {

    // MARK: - UI
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var regdate: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    // MARK: - Property
    
    let memo = PublishSubject<MemoData>()
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        memo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if $0.imageData != nil {
                    self?.img.image = UIImage(data: $0.imageData!)
                }
                self?.subject.text = $0.title
                self?.contents.text = $0.contents
                self?.regdate.text = $0.regdate.formatToString(false)
            })
            .disposed(by: disposeBag)
    }

}
