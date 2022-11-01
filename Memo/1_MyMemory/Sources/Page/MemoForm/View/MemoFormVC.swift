//
//  MemoFormVC.swift
//  1_MyMemory
//
//  Created by 권오준 on 2022/08/07.
//

import UIKit

import RxSwift

class MemoFormVC: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    // MARK: - Property
    
    let viewModel = MemoFormViewModel()
    var subject: String!
//    var lastId: Int?
//    var saveHandler: ((MemoData) -> Void)?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    // MARK: - Func
    
    func configureViewController() {
//        self.contents.delegate = self
    }
    
    func configureBindings() {
        // Input
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
    
    @IBAction func pick(_ sender: Any) {
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
