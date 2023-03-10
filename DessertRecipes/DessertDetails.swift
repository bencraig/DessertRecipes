//
//  DessertDetailsView.swift
//  DessertRecipes
//
//  Created by Benjamin Craig on 3/8/23.
//

import SwiftUI

struct DessertDetails: View {
    
    @EnvironmentObject private var store: DessertStore
    @Binding var dessert: Dessert
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        TabView {
            ingredientsList
                .tabItem {
                    Label("Ingredients", systemImage: "list.dash")
                }
            instructionsList
                .tabItem {
                    Label("Instructions", systemImage: "oven")
                }
        }
        .padding()
        .navigationTitle(dessert.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if dessert.instructions == nil {
                store.getDessertDetails(mealID: dessert.id)
            }
        }
    }
    
    //todo refactor to avoid nil coalescing optionals so often
    var ingredientsList: some View {
        List {
            Section(header: Text("Ingredients and Measurements")) {
                ForEach(dessert.ingredients?.indices ?? 0..<0, id:\.self) { index in
                    HStack {
                        Text(dessert.ingredients?[index] ?? "")
                            .frame(maxWidth:.infinity, alignment: .leading)
                        Text(dessert.measurements?[index] ?? "")
                            .frame(maxWidth:.infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
    
    private let iPadImageScale = 1.0
    private let iPhoneImageScale = 3.0
    
    var instructionsList: some View {
        ScrollView {
            Text("Instructions")
            Text(dessert.instructions ?? "")
                .font(.system(.subheadline))
                .padding()
            
            let imageScale = idiom == .pad ? iPadImageScale : iPhoneImageScale
            AsyncImage(url: dessert.imageURL, scale:imageScale)
                .aspectRatio(contentMode: .fit)
            
            if let source = dessert.sourceURL {
                Link("Source: \(source.host!)", destination: source)
                    .padding(.top)
            }
            if let youtubeURL = dessert.youtubeURL {
                Link("View on Youtube", destination: youtubeURL)
                    .padding(.top)
            }
        }
    }
}

// curious to see how bindings can work with preview, something like this but xcode not happy
/*
struct DessertDetailsView_Previews: PreviewProvider {
    // A View that simply wraps the real view we're working on
    // Its only purpose is to hold state
    struct DessertDetailsContainerView: View {
        @State private var dessert = Dessert(name: "fake", id: 123, imageURL: URL(string:"www.fake.com")!)
        
        var body: some View {
            DessertDetails(dessert: $dessert)
        }
    }
    
    static var previews: some View {
        DessertDetailsContainerView()
    }
}
*/
