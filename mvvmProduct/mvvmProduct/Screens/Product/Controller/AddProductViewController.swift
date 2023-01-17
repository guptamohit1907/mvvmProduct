//
//  AddProductViewController.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 17/01/23.
//

import UIKit
//struct AddProduct : Codable{
//    var id : Int? = nil
//    let title : String
//}
//struct ProductResponse : Decodable  {
//    let id : Int
//    let title : String
//}


class AddProductViewController: UIViewController {

     override func viewDidLoad() {
        super.viewDidLoad()
         addProduct()
    }
    
    func addProduct(){
        guard let url = URL(string: "https://dummyjson.com/products/add") else { return }
        
        let parameters = AddProduct(title: "Yogesh Patel")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        //Model to Data Convert (JSOnEncoder + Encodable)
        request.httpBody = try? JSONEncoder().encode(parameters)
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            do {
                // Data to Model Convert - JSON Decoder + Decodable
                let productResponse = try JSONDecoder().decode(AddProduct.self, from: data)
                print(productResponse)
            } catch {
                print(error)
            }
        }.resume()
    }
}
