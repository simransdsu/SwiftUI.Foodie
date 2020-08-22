import SwiftUI
import SDWebImageSwiftUI

struct RecipeDetailView: View {
    
    @State var recipe: Recipe!
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                List {
                    WebImage(url: URL(string: recipe.image_url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                    
                    ForEach(recipe.ingredients ?? [], id: \.self) { ingredient in
                        Text("\(ingredient)")
                    }
                }
            }.navigationBarTitle("\(recipe.title)", displayMode: .inline)
        }.onAppear(perform: loadRecipe)
        
    }
    
    func loadRecipe() {
        guard let url = URL(string: "https://recipesapi.herokuapp.com/api/get?rId=\(recipe.recipe_id)")
       else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("Error getting recipies: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                let data = data,
                httpResponse.statusCode == 200 {
                guard let response = try? JSONDecoder().decode(RecipeDetailResponse.self, from: data)
                else {
                    fatalError("Failed to decode JSON")
                }
                
                DispatchQueue.main.async {
                    self.recipe = response.recipe
                }
            }
        }.resume()
    }
}
  
  struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(recipe_id: "",
                                        title: "",
                                        image_url: "",
                                        publisher: "",
                                        ingredients: []))
    }
}
