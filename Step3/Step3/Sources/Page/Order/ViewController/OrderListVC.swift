//
//  OrderListVC.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import UIKit

import RxSwift
import RxCocoa

class OrderListVC: UIViewController {

    // MARK: - UI
    
    
    // MARK: - Property
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureVC()
        updateNavigationBar(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateNavigationBar(false)
    }
    
    // MARK: - Func
    
    private func configureVC() {
        
    }
    
    private func updateNavigationBar(_ bool: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bool ? .black : .white
        appearance.titleTextAttributes = [.foregroundColor: bool ? UIColor.white : UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let bar = self.navigationController?.navigationBar
        bar?.tintColor = bool ? .white : .black
        bar?.scrollEdgeAppearance = appearance
        bar?.standardAppearance = appearance
    }
    
    // MARK: - Action
    

}
