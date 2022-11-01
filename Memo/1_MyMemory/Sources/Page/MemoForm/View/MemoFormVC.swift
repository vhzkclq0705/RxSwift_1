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
            let alert = UIAlertController(
                title: nil,
                message: "내용을 입력해주세요.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
            return
        }
        
        let memo = MemoData(
            memoIdx: 0,
            title: subject,
            contents: contents.text,
            image: preview.image,
            regdate: Date())
        
        viewModel.save(memo: memo)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Action
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(
                title: nil,
                message: "내용을 입력해주세요.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
            return
        }
        
        let data = MemoData(
            memoIdx: 0,
            title: subject,
            contents: contents.text,
            image: preview.image,
            regdate: Date())
        
        //        saveHandler?(data)
        
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

// MARK: - TextViewDelegate

//extension MemoFormVC: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        let contents = textView.text as NSString
//        let length = (contents.length > 15) ? 15 : contents.length
//
//        self.subject = contents.substring(with: NSRange(location: 0, length: length))
//        self.title = self.subject
//    }
//
//}

// MARK: - NavigationControllerDelegate

extension MemoFormVC: UINavigationControllerDelegate {
    
}
