//
//  MemoReadVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoReadVC: BaseVC {

    // MARK: - UI
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var imageDeleteButton: UIButton!
    
    lazy var cameraButton = UIBarButtonItem(
        barButtonSystemItem: .camera,
        target: self,
        action: nil)
    
    lazy var completeButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: nil)
    
    // MARK: - Property
    
    var viewModel: MemoReadViewModel!
    private var disposeBag = DisposeBag()
    private var tempTitle: String? = ""
    private var tempButton1 = UIBarButtonItem()
    private var tempButton2 = UIBarButtonItem()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BindViewModel()
        configureViewController()
    }
    
    // MARK: - Bind
    
    private func BindViewModel() {
        let input = MemoReadViewModel.Input(
            updateButtonDidTapEvent: updateButton.rx.tap.asObservable(),
            deleteButtonDidTapEvent: deleteButton.rx.tap.asObservable(),
            cameraButtonDidTapEvent: cameraButton.rx.tap.asObservable(),
            completeButtonDidTapEvent: completeButton.rx.tap.asObservable(),
            imageDeleteButtonDidTapEvent: imageDeleteButton.rx.tap.asObservable(),
            title: titleTextField.rx.text.orEmpty.skip(1).asObservable(),
            contents: contentsTextView.rx.text.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.title
            .emit(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.contents
            .emit(to: contentsTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.titleLength
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.titleTextField.deleteBackward()
                }
            })
            .disposed(by: disposeBag)
        
        output.date
            .emit(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
        
        output.imgData
            .emit(onNext: { [weak self] in
                self?.imageView.image = UIImage(data: $0 ?? Data())
            })
            .disposed(by: disposeBag)
        
        output.imageDelete
            .emit(onNext: { [weak self] in
                self?.imageView.image = nil
            })
            .disposed(by: disposeBag)
        
        output.update
            .emit(onNext: { [weak self] in
                self?.isUpdate(true)
            })
            .disposed(by: disposeBag)
        
        output.complete
            .emit(onNext: { [weak self] in
                if $0 {
                    self?.presentAlert()
                } else {
                    self?.isUpdate(false)
                    self?.viewModel.updateMemo()
                }
            })
            .disposed(by: disposeBag)
        
        output.delete
            .emit(onNext: { [weak self] in
                self?.presentDeleteAlert()
            })
            .disposed(by: disposeBag)
        
        output.camera
            .emit(onNext: { [weak self] in
                self?.pickImage()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    private func configureViewController() {
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Func
    
    private func isUpdate(_ bool: Bool) {
        imageDeleteButton.isHidden = !bool
        titleTextField.isEnabled = bool
        contentsTextView.isEditable = bool
        titleTextField.backgroundColor = bool ? UIColor.systemGray5 : UIColor.white
        contentsTextView.backgroundColor = bool ? UIColor.systemGray5 : UIColor.white
        
        if bool {
            tempTitle = title
            title = "수정"
            tempButton1 = updateButton
            tempButton2 = deleteButton
            self.navigationItem.rightBarButtonItems?[1] = cameraButton
            self.navigationItem.rightBarButtonItems?[0] = completeButton
        } else {
            title = tempTitle
            self.navigationItem.rightBarButtonItems?[1] = tempButton1
            self.navigationItem.rightBarButtonItems?[0] = tempButton2
        }
    }
    
    private func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "정말 삭제하시겠어요?.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel.deleteMemo()
            self?.navigationController?.popViewController(animated: true)
        })
        
        self.present(alert, animated: true)
    }

}

// MARK: - ImagePickerControllerDelegate

extension MemoReadVC: UIImagePickerControllerDelegate {
    
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

extension MemoReadVC: UINavigationControllerDelegate {
    
}
