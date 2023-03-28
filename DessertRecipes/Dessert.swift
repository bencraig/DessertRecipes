//
//  Dessert.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/7/23.
//


// Model

import Foundation

struct Dessert : Identifiable, Hashable, Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var name: String {
        strMeal
    }
    var id: Int {
        Int(idMeal) ?? 0
    }
    var imageURL: URL? {
        URL(string: strMealThumb)
    }
    
    var instructions: String?
    var ingredients: [String]?
    var measurements: [String]?
    var imageData: Data?
    var sourceURL: URL?
    var youtubeURL: URL?
}

struct MealList: Codable {
    let meals: [Dessert]
}
