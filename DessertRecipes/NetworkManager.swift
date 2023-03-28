//
//  NetworkService.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/10/23.
//

import Foundation

enum NetworkManagerError: Error {
    case invalidURL
    case invalidResponseCode
    case decodeFailure
}

final class NetworkManager {
    private let listURLString : String
    private let detailsURLString : String
    
    init (listURLString: String, detailsURLString: String) {
        self.listURLString = listURLString
        self.detailsURLString = detailsURLString
    }
    
    func fetchDessertList() async throws -> [Dessert] {
        guard let url = URL(string: listURLString) else {
            throw NetworkManagerError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkManagerError.invalidResponseCode
        }
        guard let mealList = try JSONDecoder().decode(MealList?.self, from: data) else {
            throw NetworkManagerError.decodeFailure
        }
        return mealList.meals
    }

    // todo use JSONDecoder
    func fetchDessert(_ dessert: Dessert) async throws -> Dessert  {
        var updatedDessert = dessert
        guard let url = URL(string: detailsURLString + "\(dessert.id)") else {
            throw NetworkManagerError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkManagerError.invalidResponseCode
        }
         
        guard let parsedResult = (try? JSONSerialization.jsonObject(with: data)) as? [String : Any] else {
            throw NetworkManagerError.decodeFailure
        }
        
        guard let mealInfo = parsedResult["meals"] as? [Any] else {
            throw NetworkManagerError.decodeFailure
        }
        
        guard let mealDetails = mealInfo[0] as? [String: Any] else {
            throw NetworkManagerError.decodeFailure
        }
        
        if let instructions = mealDetails["strInstructions"] as? String {
            updatedDessert.instructions = instructions
        }
        
        if let youtube = mealDetails["strYoutube"] as? String {
            updatedDessert.youtubeURL = URL(string: youtube)
        }
        
        if let source = mealDetails["strSource"] as? String {
            updatedDessert.sourceURL = URL(string: source)
        }
        
        let maxComponents = 20
        var componentNumber = 1
        var ingredients = [String]()
        var measurements = [String]()
        while componentNumber <= maxComponents {
            let ingredientString = "strIngredient\(componentNumber)"
            let measurementString = "strMeasure\(componentNumber)"
            
            if let ingredient = mealDetails[ingredientString] as? String, ingredient != "" {
                ingredients.append(ingredient)
            } else {
                break
            }
            
            if let measurement = mealDetails[measurementString] as? String, measurement != "" {
                measurements.append(measurement)
            } else {
                break
            }
            
            componentNumber += 1
        }
        
        updatedDessert.measurements = measurements
        updatedDessert.ingredients = ingredients
                
        return updatedDessert
    }
}
