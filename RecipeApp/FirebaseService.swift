//
//  FirebaseService.swift
//  RecipeApp
//
//  Created by mac on 6/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

struct FirebaseService {
  
  func saveRecipeDetail(recipeDetail: RecipeDetail, completion: @escaping (Result<Void, Error>) -> Void) {
    let db = Firestore.firestore()
    
    do {
      // Convert RecipeDetail to dictionary
      let data = try JSONEncoder().encode(recipeDetail)
      let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      
      // Check if name is provided
      guard let name = recipeDetail.name else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Recipe name is missing."])))
        return
      }
      
      // Save to Firestore with the name as document ID
      db.collection("recipes").document(name).setData(json ?? [:]) { error in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(()))
        }
      }
    } catch {
      completion(.failure(error))
    }
  }
  
  func fetchRecipes(completion: @escaping (Result<[RecipeDetail], Error>) -> Void) {
    let db = Firestore.firestore()
    db.collection("recipes").getDocuments { snapshot, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let documents = snapshot?.documents else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found."])))
        return
      }
      
      let recipes: [RecipeDetail] = documents.compactMap { document in
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
          let recipe = try JSONDecoder().decode(RecipeDetail.self, from: jsonData)
          
          return recipe
        } catch {
          print("Error decoding document: \(error)")
          return nil
        }
      }
      
      completion(.success(recipes))
    }
  }
  
}
