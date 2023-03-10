//
//  NetworkService.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/10/23.
//

import Foundation

struct NetworkService: DataService {
    private let listURLString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    private let detailsURLString = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    
    func fetchDessertList() async -> [Dessert]  {
        var resultList = [Dessert]()
        let url = URL(string: listURLString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
        
            guard let parsedResult = (try? JSONSerialization.jsonObject(with: data)) as? [String : Any] else {
                print("Could not parse the data as JSON: '\(data)'")
                return resultList
            }
            
            guard let meals = parsedResult["meals"] as? Array<[String: String]> else {
                print("Could not parse the data as JSON: '\(data)'")
                return resultList
            }
            
            for m in meals {
                let dessertName = m["strMeal", default: ""]
                let dessertID = Int(m["idMeal", default: ""])
                let url = URL(string: m["strMealThumb", default:""] )
                let newDessert = Dessert(name:dessertName, id: dessertID!, imageURL: url!)
                resultList.append(newDessert)
            }
            
        } catch {
            print("HTTP Request Failed")
        }
        
        return resultList
    }
    
    func fetchDessert(_ dessert: Dessert) async -> Dessert  {
        var updatedDessert = dessert
        let url = URL(string: detailsURLString + "\(dessert.id)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let parsedResult = (try? JSONSerialization.jsonObject(with: data)) as? [String : Any] else {
                print("Could not parse the data as JSON: '\(data)'")
                return updatedDessert
            }
            
            guard let mealInfo = parsedResult["meals"] as? [Any] else {
                print("Could not parse the data as JSON: '\(data)'")
                return updatedDessert
            }
            
            guard let mealDetails = mealInfo[0] as? [String: Any] else {
                print("Could not parse the data as JSON: '\(data)'")
                return updatedDessert
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
            
        } catch {
            print("HTTP Request Failed")
        }
                
        return updatedDessert
    }
    
}
