//
//  MainView.swift
//  RecipeApp
//
//  Created by mac on 6/11/24.
//

import SwiftUI

struct MainView: View {
  @State private var selectedTab = 0
  
  var body: some View {
    TabView(selection: $selectedTab) {
      SearchView()
        .tabItem {
          Image(systemName: "house")
          Text("홈")
        }
        .tag(0)
      
      BookmarkView()
        .tabItem {
          Image(systemName: "bookmark")
          Text("북마크")
        }
        .tag(1)
    }
  }
}

#Preview {
  MainView()
}

