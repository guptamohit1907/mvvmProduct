//
//  APIManager.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 04/01/23.
//

enum DataErrror : Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias Handler = (Result<[Product], DataErrror>) -> Void

import UIKit
// MARK :- Singleton Design Pattern
// if the class is final we cannot inherit it 
final class APIManager{
    static let shared = APIManager()
    // class object is inaccesible outside the class
    // Error :- 'APIManager' initializer is inaccessible due to 'private' protection level
    private init(){
        
    }
    func fetchProducts(completion : @escaping Handler){
        guard let url = URL(string: Constant.API.productURL) else {
            return
        }
        // background TasK
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse  ,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            // JSONDEcoder() - Data ka model Array mai convert krega
            do {
                let products = try JSONDecoder().decode([Product].self,from: data)
                completion(.success(products))
            }
            catch{
                completion(.failure(.network(error)))
            }
        }.resume()
        print("Ended")
    }
}
//class A {
//    func configuration(){
//        let manager = APIManager()
//        manager.temp()
//        APIManager.shared.temp()
//    }
//}
// singleton - singleton class ka object create hoga outside of the class
//  Example - urlsession
// Singleton - Singleton class ka object create nhi hoga outside of the class