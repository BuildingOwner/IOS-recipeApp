//
//  BundleKeyLoad.swift
//  RecipeApp
//
//  Created by mac on 6/13/24.
//

import Foundation

extension Bundle{
  var OpenAiKey: String {
    guard let file = self.path(forResource: "key", ofType: "plist") else { return ""}
    
    guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
    
    guard let key = resource["openAIKey"] as? String else {
      fatalError("openAi 키 로드 실패")
    }
    
    return key
  }
}
