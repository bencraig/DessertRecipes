//
//  DessertStore.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/7/23.
//

// ViewModel
// 
import Foundation

class DessertStore: ObservableObject {
    @Published var desserts = [Dessert]() {
        didSet {
            // todo persistence
        }
    }
    
    func fetchDessertList() {
        //todo hard code refactor
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                guard let parsedResult = (try? JSONSerialization.jsonObject(with: data)) as? [String : Any] else {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let meals = parsedResult["meals"] as? Array<[String: String]>
                else {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                for m in meals {
                    let dessertName = m["strMeal", default: ""]
                    let dessertID = Int(m["idMeal", default: ""])
                    let url = URL(string: m["strMealThumb", default:""] )
                    let newDessert = Dessert(name:dessertName, id: dessertID!, imageURL: url!)
                    DispatchQueue.main.async {
                        self.desserts.append(newDessert)
                    }
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
    
    func fetchDessert(mealID: Int) {
        //todo refactor hard coding
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                guard let parsedResult = (try? JSONSerialization.jsonObject(with: data)) as? [String : Any] else {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let mealInfo = parsedResult["meals"] as? [Any] else {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let mealDetails = mealInfo[0] as? [String: Any] else {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                guard let dessertIndex = self.desserts.firstIndex(where: {$0.id == mealID}) else {
                    print("dessert not found")
                    return
                }
                
                var dessert = self.desserts[dessertIndex]
                
                if let instructions = mealDetails["strInstructions"] as? String {
                    dessert.instructions = instructions
                }
                
                if let youtube = mealDetails["strYoutube"] as? String {
                    dessert.youtubeURL = URL(string: youtube)
                }
                
                if let source = mealDetails["strSource"] as? String {
                    dessert.sourceURL = URL(string: source)
                }
                
                var componentNumber = 1
                let maxComponents = 20
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
                
                dessert.measurements = measurements
                dessert.ingredients = ingredients
                
                DispatchQueue.main.async {
                    self.desserts[dessertIndex] = dessert
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }
    
    init () {
        fetchDessertList()
    }
}
