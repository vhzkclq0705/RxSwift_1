//
//  MemoFormVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoFormVC: BaseVC {
    
    // MARK: - UI
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageDeleteButton: UIButton!
    
    // MARK: - Property
    
    private let viewModel = MemoFormViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        bindViewModel()
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = MemoFormViewModel.Input(
            cameraButtonDidTapEvent: cameraButton.rx.tap.asObservable(),
            saveButtonDidTapEvent: saveButton.rx.tap.asObservable(),
            imageDeleteButtonDidTapEvent: imageDeleteButton.rx.tap.asObservable(),
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
        
        output.imageDelete
            .emit(onNext: { [weak self] in
                self?.imageView.image = nil
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Func
    
    private func configureViewController() {
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func validateSave(_ bool: Bool) {
        if bool {
            self.presentAlert()
        } else {
            self.viewModel.saveMemo()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func pickImage() {
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
                self?.imageView.image = UIImage(data: $0!)
            })
            .disposed(by: disposeBag)
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - NavigationControllerDelegate

extension MemoFormVC: UINavigationControllerDelegate {
    
}
