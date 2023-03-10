//
//  Dessert.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/7/23.
//


// Model

import Foundation

struct Dessert : Identifiable, Hashable { // todo codable 
    let name: String
    let id: Int
    let imageURL: URL
    
    var instructions: String?
    var ingredients: [String]?
    var measurements: [String]?
    var imageData: Data?
    var sourceURL: URL?
    var youtubeURL: URL?
}
