//
//  DataService.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/10/23.
//

import Foundation

protocol DataService {
    
    func fetchDessertList() async throws -> [Dessert]
    func fetchDessert(_ dessert: Dessert) async -> Dessert
    
}
