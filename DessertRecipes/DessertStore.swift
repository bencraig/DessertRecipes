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
    @Published var desserts = [Dessert]() //todo persistence
    
    private let networkManager: NetworkManager
        
    init () {
        networkManager = NetworkManager(
            listURLString: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert",
            detailsURLString: "https://themealdb.com/api/json/v1/1/lookup.php?i="
        )
        
        Task {
            await loadDessertList()
        }
    }
    
    func loadDessertList() async {
        do {
            let dessertList = try await networkManager.fetchDessertList()
            await MainActor.run {
                self.desserts = dessertList
            }
        } catch {
            print(error)
        }
    }
    
    func getDessertDetails(dessertID: Int) async {
        guard let dessertIndex = self.desserts.firstIndex(where: {$0.id == dessertID}) else {
            print("dessert not found")
            return
        }
        
        do {
            let detailedDessert = try await networkManager.fetchDessert(desserts[dessertIndex])
            await MainActor.run {
                self.desserts[dessertIndex] = detailedDessert
            }
        } catch {
            print(error)
        }
    }
}
