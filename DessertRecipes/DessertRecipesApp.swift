//
//  DessertRecipesApp.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/7/23.
//

import SwiftUI

@main
struct DessertRecipesApp: App {
    @StateObject var dessertStore = DessertStore()

    var body: some Scene {
        WindowGroup {
            DessertList()
                .environmentObject(dessertStore) 
        }
    }
}
