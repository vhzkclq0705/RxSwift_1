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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
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
    var disposeBag = DisposeBag()
    var tempTitle: String? = ""
    var tempButton1 = UIBarButtonItem()
    var tempButton2 = UIBarButtonItem()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BindViewModel()
        configureViewController()
    }
    
    // MARK: - Bind
    
    func BindViewModel() {
        let input = MemoReadViewModel.Input(
            updateButtonDidTapEvent: updateButton.rx.tap.asObservable(),
            deleteButtonDidTapEvent: deleteButton.rx.tap.asObservable(),
            cameraButtonDidTapEvent: cameraButton.rx.tap.asObservable(),
            completeButtonDidTapEvent: completeButton.rx.tap.asObservable(),
            title: titleTextField.rx.text.orEmpty.asObservable(),
            contents: contentsTextView.rx.text.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.title
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.contents
            .bind(to: contentsTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.title = $0
            })
            .disposed(by: disposeBag)
        
        output.imgData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.imageView.image = UIImage(data: $0 ?? Data())
            })
            .disposed(by: disposeBag)
        
        output.update
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.isUpdate(true)
            })
            .disposed(by: disposeBag)
        
        output.complete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.isUpdate(false)
                self?.viewModel.updateMemo()
            })
            .disposed(by: disposeBag)
        
        output.delete
            .subscribe(onNext: { [weak self] in
                self?.presentAlert()
            })
            .disposed(by: disposeBag)
        
        output.camera
            .subscribe(onNext: { [weak self] in
                self?.pickImage()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func configureViewController() {
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Func
    
    func isUpdate(_ bool: Bool) {
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
    
    func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
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
