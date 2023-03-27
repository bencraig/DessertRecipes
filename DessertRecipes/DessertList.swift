//
//  DessertList.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/7/23.
//

import SwiftUI

struct DessertList: View {
    @EnvironmentObject private var store: DessertStore

    private let thumbnailScale = 20.0
    private let progressScale = 3.0
    private let navTitle = "Dessert Recipes"
    
    var body: some View {
        NavigationStack {
            if store.desserts.isEmpty {
                ProgressView()
                    .scaleEffect(progressScale)
            } else {
                List {
                    ForEach(store.desserts) { dessert in
                        NavigationLink (destination: DessertDetails(dessert: $store.desserts[dessert])){
                            LazyHStack {
                                AsyncImage(url: dessert.imageURL, content: { thumbImage in
                                    thumbImage
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .scaledToFit()
                                        .cornerRadius(5)
                                }, placeholder: {
                                    ProgressView()
                                })
                                Spacer()
                                Text(dessert.name)
                            }
                        }
                    }
                }
                .navigationTitle(navTitle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DessertList()
    }
}
