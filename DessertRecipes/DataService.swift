//
//  DataService.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/10/23.
//

import Foundation

protocol DataService {
    
    func fetchDessertList() async -> [Dessert]
    func fetchDessert(_ dessert: Dessert) async -> Dessert
    
}
