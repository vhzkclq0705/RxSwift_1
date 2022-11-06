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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: - Property
    
    let viewModel = MemoFormViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Bind
    
    func bindViewModel() {
        let input = MemoFormViewModel.Input(
            cameraButtonDidTapEvent: cameraButton.rx.tap.asObservable(),
            saveButtonDidTapEvent: saveButton.rx.tap.asObservable(),
            title: titleTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
            contents: contentsTextView.rx.text.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.title
            .emit(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
        
        output.titleLength
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.titleTextField.deleteBackward()
                }
            })
            .disposed(by: disposeBag)
        
        output.showImagePicker
            .emit(onNext: { [weak self] in
                self?.pickImage()
            })
            .disposed(by: disposeBag)
        
        output.saveMemoAndPop
            .emit(onNext: { [weak self] in
                self?.validateSave($0)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Func
    
    func validateSave(_ bool: Bool) {
        if bool {
            self.presentAlert()
        } else {
            self.viewModel.saveMemo()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
    }
    
}

// MARK: - ImagePickerControllerDelegate

extension MemoFormVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        viewModel.setImage((info[.editedImage] as? UIImage)?.pngData())
            .subscribe(onNext: { [weak self] in
                self?.preview.image = UIImage(data: $0!)
            })
            .disposed(by: disposeBag)
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - NavigationControllerDelegate

extension MemoFormVC: UINavigationControllerDelegate {
    
}
