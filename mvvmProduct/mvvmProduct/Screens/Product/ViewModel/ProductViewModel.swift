//
//  ProductViewModel.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 05/01/23.
//

import Foundation
// resume from 53:55
final class ProductViewModel {
    var products : [Product] = []
    var eventHandler: ((_ event : Event) -> Void)? // Data Binding Closure
    
    func fetchProducts(){
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: [Product].self
         , type: EndPointItems.products
         , completion: { response in
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products) :
                self.products = products
                self.eventHandler?(.dataLoaded)
            case .failure(let error) :
                self.eventHandler?(.error(error))
            }
        })
    }
    
//    func fetchProducts(){
//        self.eventHandler?(.loading)
//        APIManager.shared.fetchProducts { response in
//            self.eventHandler?(.stopLoading)
//            switch response {
//            case .success(let products) :
//                self.products = products
//                self.eventHandler?(.dataLoaded)
//            case .failure(let error) :
//                self.eventHandler?(.error(error))
//            }
//        }
//    }
    
    
}
extension ProductViewModel {
    enum Event {
    case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
