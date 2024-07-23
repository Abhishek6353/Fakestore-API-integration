//
//  User.swift
//  FakeStore
//
//  Created by Abhishek on 23/07/24.
//

import Foundation


// Rating Model
struct Rating: Codable {
    let rate: Double
    let count: Int
}

// Product Model
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}
