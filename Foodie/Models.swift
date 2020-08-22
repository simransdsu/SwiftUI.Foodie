//
//  Models.swift
//  Foodie
//
//  Created by jc on 2020-08-20.
//  Copyright © 2020 jc. All rights reserved.
//

import Foundation


struct Recipe : Codable {
    var recipe_id: String
    let title: String
    let image_url: String
    let publisher: String
    let ingredients: [String]?
}

struct RecipeDetailResponse: Codable {
    let recipe: Recipe
}

struct RecipiesResponse : Codable {
    var recipes: [Recipe]
    var count: Int
}
