//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by mac on 6/11/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

@main
struct RecipeAppApp: App {
  init(){
    // firebase 연결
    FirebaseApp.configure()
   
    // firestore에 저장
    Firestore.firestore().collection("test").document("name").setData(["name": "Jaewan Choi"])
  }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

