//
//  Day21.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Food {
  let ingredients: Set<String>
  let allergens: Set<String>
  
  init?(data: String) {
    let components = data.components(separatedBy: " (contains ")
    guard components.count == 2 else { return nil }
    ingredients = Set(components[0].components(separatedBy: .whitespaces))
    allergens = Set(components[1].dropLast().components(separatedBy: ", "))
  }
}

class Day21: Day {
  override init(input: String) {
    foods = input.lines().compactMap { Food.init(data: $0) }
    super.init(input: input)
  }
  
  let foods: [Food]
  
  /// Determine which ingredients cannot possibly contain any of the allergens in your list. How many times do any of those ingredients appear?
  func part1() -> String {
    var allergenPossibilities: [String: [Set<String>]] = [:] // map of allergen name to different sets of ingredients it could possibly be in
    foods.forEach { food in
      food.allergens.forEach { allergen in
        if nil == allergenPossibilities[allergen] {
          allergenPossibilities[allergen] = [food.ingredients]
        } else {
          allergenPossibilities[allergen]?.append(food.ingredients)
        }
      }
    }
    
    let allIngredients = foods.reduce(Set<String>()) { $0.union($1.ingredients) }
    var ingredientMappedByAllergen: [String: String] = [:] // Each allergen is found in exactly one ingredient
    
    while allergenPossibilities.count != ingredientMappedByAllergen.count {
      
      for (allergen, possibilities) in allergenPossibilities {
        if ingredientMappedByAllergen[allergen] != nil {
          continue
        }
        let commonIngredients = possibilities.reduce(possibilities.first!) { $0.intersection($1) }
        // look for a single ingredient containing the allergen that we haven't already identified
        let unknownIngredients = commonIngredients.subtracting(ingredientMappedByAllergen.values)
        if unknownIngredients.count == 1 {
          ingredientMappedByAllergen[allergen] = unknownIngredients.first!
          break
        }
      }
      
    }
    
    let safeIngredients = allIngredients.subtracting(ingredientMappedByAllergen.values)
    let appearingCount = foods.reduce(0) { $0 + $1.ingredients.intersection(safeIngredients).count }
      
    return String(appearingCount)
  }
  
  /// Arrange the ingredients alphabetically by their allergen and separate them by commas to produce your canonical dangerous ingredient list.
  func part2() -> String {
    var allergenPossibilities: [String: [Set<String>]] = [:] // map of allergen name to different sets of ingredients it could possibly be in
    foods.forEach { food in
      food.allergens.forEach { allergen in
        if nil == allergenPossibilities[allergen] {
          allergenPossibilities[allergen] = [food.ingredients]
        } else {
          allergenPossibilities[allergen]?.append(food.ingredients)
        }
      }
    }
    
    var ingredientMappedByAllergen: [String: String] = [:] // Each allergen is found in exactly one ingredient
    
    while allergenPossibilities.count != ingredientMappedByAllergen.count {
      
      for (allergen, possibilities) in allergenPossibilities {
        if ingredientMappedByAllergen[allergen] != nil {
          continue
        }
        let commonIngredients = possibilities.reduce(possibilities.first!) { $0.intersection($1) }
        // look for a single ingredient containing the allergen that we haven't already identified
        let unknownIngredients = commonIngredients.subtracting(ingredientMappedByAllergen.values)
        if unknownIngredients.count == 1 {
          ingredientMappedByAllergen[allergen] = unknownIngredients.first!
          break
        }
      }
      
    }
    
    return (ingredientMappedByAllergen.keys.sorted().compactMap { ingredientMappedByAllergen[$0] }.joined(separator: ","))
  }
}
