//
//  MenuListViewModel.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import RxSwift
import RxCocoa

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
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                    return []
                }
                
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { index, item in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: self.menus)
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
                            count: max($0.count + num, 0))
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
    
    func onOrder() {
        
    }
}
