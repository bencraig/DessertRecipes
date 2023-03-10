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
    
    private let dataSource: DataService
        
    init () {
        dataSource = NetworkService()
        
        loadDessertList()
    }
    
    func loadDessertList() {
        Task {
            let listResults = await dataSource.fetchDessertList()
            
            DispatchQueue.main.async {
                self.desserts = listResults
            }
        }
    }
    
    func getDessertDetails(mealID: Int) {
        guard let dessertIndex = self.desserts.firstIndex(where: {$0.id == mealID}) else {
            print("dessert not found")
            return
        }
        
        Task {
            let detailedDessert = await dataSource.fetchDessert(desserts[dessertIndex])
            
            DispatchQueue.main.async {
                self.desserts[dessertIndex] = detailedDessert
            }
        }
    }
}
