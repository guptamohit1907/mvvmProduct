//
//  APIManager.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 04/01/23.
//

import Foundation
import UIKit


enum DataErrror : Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

//typealias Handler = (Result<[Product], DataErrror>) -> Void
typealias Handler<T> = (Result<T, DataErrror>) -> Void


// MARK :- Singleton Design Pattern
// if the class is final we cannot inherit it 
final class APIManager{
    static let shared = APIManager()
    // class object is inaccesible outside the class
    // Error :- 'APIManager' initializer is inaccessible due to 'private' protection level
    private init(){}
    
    func request<T: Codable>(
        modelType : T.Type,
        type : EndPointType,
        completion : @escaping Handler<T>
    ){
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if let parameters = type.body {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        request.allHTTPHeaderFields = type.headers
        
        // background TasK
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                let products = try JSONDecoder().decode(modelType    ,from: data)
                completion(.success(products))
            }
            catch{
                completion(.failure(.network(error)))
            }
        }.resume()
        print("Ended")
    }
    
    static var commonHeaders : [String : String] {
        return [
            "Content-Type" : "application/json"
        ]
    }
    
//    func fetchProducts(completion : @escaping Handler){
//    }
    
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
