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
            instructionsList
                .tabItem {
                    Label("Instructions", systemImage: "oven")
                }
            ingredientsList
                .tabItem {
                    Label("Ingredients", systemImage: "list.dash")
                }
        }
        .padding()
        .navigationTitle(dessert.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if dessert.instructions == nil {
                store.getDessertDetails(mealID: dessert.id)
            }
        }
    }
    
    var ingredientsList: some View {
        List {
            Section(header: Text("Ingredients and Measurements")) {
                ForEach(dessert.ingredientList.indices, id:\.self) { index in
                    HStack {
                        Text(dessert.ingredientList[index])
                            .frame(maxWidth:.infinity, alignment: .leading)
                        Text(dessert.measurementList[index])
                            .frame(maxWidth:.infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
    
    private let iPadImageFactor = 3.0
    private let iPhoneImageFactor = 1.0
    private let imageSize = 200.0

    var instructionsList: some View {
        ScrollView {
            Text("Instructions")
            Text(dessert.instructionText)
                .font(.system(.subheadline))
                .padding()
            
            let imageScale = idiom == .pad ? iPadImageFactor : iPhoneImageFactor
            AsyncImage(url: dessert.imageURL, content: { thumbImage in
                thumbImage
                    .resizable()
                    .frame(width: imageSize * imageScale, height: imageSize * imageScale)
                    .scaledToFit()
                    .cornerRadius(5)
            }, placeholder: {
                ProgressView()
            })

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

//todo fix - curious to see how bindings can work with preview, something like this but xcode not happy
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
