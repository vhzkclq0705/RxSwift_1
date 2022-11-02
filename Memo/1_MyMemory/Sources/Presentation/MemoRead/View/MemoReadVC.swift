//
//  MemoReadVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift
import RxCocoa

class MemoReadVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    // MARK: - Property
    
    var viewModel: MemoReadViewModel?
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
    }
    
    // MARK: - Configure
    
    func configureBindings() {
        viewModel?.output.memo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.subject.text = $0.title
                self?.contents.text = $0.contents
                self?.img.image = $0.image
                self?.title = $0.regdate!.formatToString(true)
            })
            .disposed(by: disposeBag)
    }

}
