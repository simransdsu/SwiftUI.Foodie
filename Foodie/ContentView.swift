//
//  ContentView.swift
//  Foodie
//
//  Created by jc on 2020-08-11.
//  Copyright © 2020 jc. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @State var recipes = [Recipe]()
    
    var body: some View {
            NavigationView {
                List(recipes, id: \.recipe_id) { recipe in
                    // Set destination to a Text with recipe.title
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        ZStack(alignment: .bottomLeading) {
                            WebImage(url: URL(string: recipe.image_url))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 150)
                            .cornerRadius(10)

                            Rectangle()
                                .background(Color.black)
                                .cornerRadius(10)
                                .opacity(0.25)
                                .frame(maxHeight: 150)

                            VStack(alignment: .leading) {
                                Text(recipe.title).font(.system(size: 20))
                                Text(recipe.publisher).font(.footnote)
                            }.foregroundColor(.white)
                             .padding([.leading, .bottom], 10)
                        }.padding(.trailing, 16)
                    }
                }
                .padding(.trailing, -32)
                .onAppear(perform: loadRecipies)
                .navigationBarTitle("Foodie")
            }
        }
    
    func loadRecipies() {
        guard let url = URL(string: "https://recipesapi.herokuapp.com/api/search") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("Error getting recipies: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                let data = data,
                httpResponse.statusCode == 200 {
                guard let response = try? JSONDecoder().decode(RecipiesResponse.self, from: data) else {
                    fatalError("Failed to decode JSON")
                }
                
                self.recipes = response.recipes
            }
        }.resume()
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
