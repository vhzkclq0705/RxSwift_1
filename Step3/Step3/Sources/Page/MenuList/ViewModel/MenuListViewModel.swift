//
//  MenuListViewModel.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import RxSwift

class MenuListViewModel {
    
    // MARK: - Property
    
    var menus = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menus.map {
        $0.map { $0.count }
            .reduce(0, +)
    }
    
    lazy var totalPrice = menus.map {
        $0.map { $0.price * $0.count }
            .reduce(0, +)
    }
    
    // MARK: - Init
    
    init() {
        let menus: [Menu] = [
            Menu(id: 0, name: "1", price: 100, count: 0),
            Menu(id: 1, name: "2", price: 200, count: 0),
            Menu(id: 2, name: "3", price: 300, count: 0),
            Menu(id: 3, name: "4", price: 400, count: 0),
        ]
        
        self.menus.onNext(menus)
    }
    
    // MARK: - Func
    
    func changeCount(_ item: Menu, _ num: Int) {
        _ = self.menus
            .map {
                return $0.map {
                    if $0.id == item.id {
                        return Menu(
                            id: $0.id,
                            name: $0.name,
                            price: $0.price,
                            count: $0.count + num)
                    } else {
                        return Menu(
                            id: $0.id,
                            name: $0.name,
                            price: $0.price,
                            count: $0.count)
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menus.onNext($0)
            })
    }
    
    func clearAllItemSelections() {
        _ = self.menus
            .map {
                return $0.map {
                    Menu(id: $0.id, name: $0.name, price: $0.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menus.onNext($0)
            })
    }
}
