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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
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
                if $0.imageData != nil {
                    self?.img.image = UIImage(data: $0.imageData!)
                }
                self?.subject.text = $0.title
                self?.contents.text = $0.contents
                self?.title = $0.regdate.formatToString(true)
            })
            .disposed(by: disposeBag)
    }

}
