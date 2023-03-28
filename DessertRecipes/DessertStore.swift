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
    
    private let networkManager: NetworkManager
        
    init () {
        networkManager = NetworkManager() // todo dependency injection

        loadDessertList()
    }
    
    func loadDessertList() {
        Task {
            do {
                let dessertList = try await networkManager.fetchDessertList()
                await MainActor.run {
                    self.desserts = dessertList
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getDessertDetails(mealID: Int) {
        guard let dessertIndex = self.desserts.firstIndex(where: {$0.id == mealID}) else {
            print("dessert not found")
            return
        }
        
        Task {
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
}
