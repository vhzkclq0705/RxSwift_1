//
//  MemoFormVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift
import RxCocoa

class MemoFormVC: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: - Property
    
    let viewModel = MemoFormViewModel()
    var disposeBag = DisposeBag()
    var subject: String!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
    }
    
    // MARK: - Configure
    
    func configureBindings() {
        // Input
        
        cameraButton.rx.tap
            .bind(to: viewModel.input.cameraButtonDidTapEvent)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.input.saveButtonDidTapEvent)
            .disposed(by: disposeBag)
        
        contents.rx.text
            .orEmpty
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.textDidChanged($0)
            })
            .disposed(by: disposeBag)
        
        // Output
        
        viewModel.output.showImagePicker
            .subscribe(onNext: { [weak self] in
                self?.pickImage()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.saveMemoAndPop
            .subscribe(onNext: { [weak self] in
                self?.saveMemo()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Func
    
    func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
    }
    
    func textDidChanged(_ string: ControlProperty<String>.Element) {
        let text = string as NSString
        let length = (text.length > 15) ? 15 : text.length
        
        self.subject = text.substring(with: NSRange(location: 0, length: length))
        self.title = self.subject
    }
    
    func saveMemo() {
        guard self.contents.text?.isEmpty == false else {
            presentAlert()
            return
        }
        
        let contents = self.contents.text
        let img = preview.image?.pngData()
        
        viewModel.saveMemo(title: subject, contents: contents, img: img, date: Date())
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ImagePickerControllerDelegate

extension MemoFormVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.preview.image = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - NavigationControllerDelegate

extension MemoFormVC: UINavigationControllerDelegate {
    
}
