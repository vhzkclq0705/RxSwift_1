//
//  MenuListViewModel.swift
//  Step3
//
//  Created by 권오준 on 2022/10/24.
//

import RxSwift
import RxCocoa
import RxRelay

class MenuListViewModel {
    
    // MARK: - Property
    
    // UI 작업은 BehaviorSubject 대신 BehaviorRelay를 사용하는 것이 좋다.
    // 이유: UI와 연결된 stream이 끊기는 것을 방지해 준다.
    var menus = BehaviorRelay<[Menu]>(value: [])
    
    lazy var itemsCount = menus.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menus.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
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
                self.menus.accept($0)
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
                self.menus.accept($0)
            })
    }
    
    func onOrder() {
        
    }
}
