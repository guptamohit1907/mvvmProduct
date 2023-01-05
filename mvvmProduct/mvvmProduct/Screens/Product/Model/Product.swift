//
//  Product.swift
//  mvvmProduct
//
//  Created by Mohit Gupta on 04/01/23.
//

import Foundation
struct Product : Decodable {
    let id : Int
    let title : String
    let price : Float
    let description : String
    let category : String
    let image : String
    let rating : Rate
}

struct Rate : Decodable {
    let rate : Float
    let count : Int
}
